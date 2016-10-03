{-# LANGUAGE RecordWildCards #-}
module Main where

import Network.Wai.Application.Static (staticApp,
                                       defaultFileServerSettings,
                                       ssListing)
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.RequestLogger (logStdout)
import Options.Applicative (info, option, auto, long, short, metavar,
                            help, value, execParser, (<>), progDesc,
                            strOption, helper, switch)
import System.Directory (makeAbsolute)
import System.IO (hPutStrLn, stderr)
import WaiAppStatic.Listing (defaultListing)

-- | Available options (parsed from command line)
data Options = Options {
  oPort :: Int,
  oDirectory :: FilePath,
  oEnableListing :: Bool
}

getOptions :: IO Options
getOptions = do
  let portParser = option auto $
        long "port"
         <> short 'p'
         <> metavar "PORT"
         <> help "Listen on this port"
         <> value 5000
      dirParser = strOption $
        long "directory"
         <> short 'd'
         <> metavar "DIR"
         <> help "Serve this directory"
         <> value "."
      enableListing = switch $
        long "enable-listing"
        <> help "Enable directory listings (file browsing)"
      parser = Options <$> portParser <*> dirParser <*> enableListing
      opts = info (helper <*> parser)
                  (progDesc "Static asset server")
  execParser opts

main :: IO ()
main = do
  Options{..} <- getOptions
  absPath <- makeAbsolute oDirectory
  let listingSettings = case oEnableListing of
        True -> Just defaultListing
        False -> Nothing
      settings = (defaultFileServerSettings oDirectory) {
                   ssListing = listingSettings
                   }
      app = logStdout $ staticApp settings
  hPutStrLn stderr $ "Serving " ++ absPath ++ " on " ++ show oPort
                   ++ "; Directory listing is "
                   ++ if oEnableListing then "enabled." else "disabled."
  run oPort app
