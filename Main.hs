{-# LANGUAGE TemplateHaskell #-}

module Main where

import Codec.Compression.Zlib ()

$(return []) -- this no-op TH splice is required to trigger the problem

main = return ()
