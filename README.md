# Trac #11042

Steps to reproduce:

1. Set up a NixOS system
2. `$ nix-shell --pure`
3. `$ cabal install zlib`
4. `$ cabal build -v2`

(`-v2` specifies output verbosity, not a version)

You will see the following failure:

```
<command line>: can't load .so/.DLL for: libz.so (libz.so: cannot open shared object file: No such file or directory)
```

The GHC invocation that fails is printed on the previous line and looks like
this:

```
/nix/store/a0dr5x063v0zm8z0z5fwh8dldg10yl07-ghc-8.4.3/bin/ghc --make -fbuilding-cabal-package -O -static -outputdir dist/build/b/b-tmp -odir dist/build/b/b-tmp -hidir dist/build/b/b-tmp -stubdir dist/build/b/b-tmp -i -idist/build/b/b-tmp -i. -idist/build/b/autogen -idist/build/global-autogen -Idist/build/b/autogen -Idist/build/global-autogen -Idist/build/b/b-tmp -optP-include -optPdist/build/b/autogen/cabal_macros.h -hide-all-packages -Wmissing-home-modules -package-db dist/package.conf.inplace -package-id base-4.11.1.0 -package-id zlib-0.6.2-5t89gesQUWsKgPz4IjNOwP -package-id bytestring-0.10.8.2 -XHaskell2010 ./Main.hs -o dist/build/b/b
```

We can trigger the error again without `cabal` by running GHC manually with
these flags. We need `cabal` only to set up the necessary environment (to
install `zlib`).

A workaround for this linking issue is to modify the `LD_LIBRARY_PATH`
environment variable by adding the following lines to `shell.nix`:

```
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.zlib}/lib:$LD_LIBRARY_PATH
  '';
```

Now running the same GHC command will succeed.
