# Trac #11042

Steps to reproduce:

1. Set up a NixOS system
2. `$ nix-shell --pure`
3. `$ cabal install zlib` (this will install `zlib` to `$HOME/.ghc`)
4. `$ ghc --make -static -package base -package zlib -package bytestring ./Main.hs`

You will see the following failure:

```
<command line>: can't load .so/.DLL for: libz.so (libz.so: cannot open shared object file: No such file or directory)
```

A workaround for this linking issue is to modify the `LD_LIBRARY_PATH`
environment variable by adding the following lines to `shell.nix`:

```
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.zlib}/lib:$LD_LIBRARY_PATH
  '';
```

Now running the same GHC command will succeed.
