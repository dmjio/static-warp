{-# LANGUAGE DataKinds #-}
module Main where

import Network.Wai.Handler.Warp
import Network.Wai.Application.Static

main :: IO ()
main = do
  putStrLn "Running on 8000..."
  run 8000 $ staticApp (defaultFileServerSettings ".")
