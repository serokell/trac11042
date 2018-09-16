{-# LANGUAGE TemplateHaskell #-}

module Main where

import Codec.Compression.Zlib
import qualified Data.ByteString.Lazy.Char8 as BS

main = print $ compress $ BS.pack $( [| "test" |] )
