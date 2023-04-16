{-# LANGUAGE TypeApplications #-}

module Main where

import           Cardano.Server.Test.Utils       (withCardanoServer)
import           Control.Exception               (bracket, bracket_, try)
import           Control.Monad                   (void)
import           Encoins.Relay.Server.Server     (mkServerHandle)
import qualified Encoins.Relay.Server.ServerSpec as Server
import           System.Directory                (createDirectoryIfMissing, removeDirectoryRecursive, renameDirectory)

main :: IO ()
main = bracket_ 
    (try @IOError (renameDirectory "secrets" "secrets_") >> createDirectoryIfMissing True "secrets") 
    (removeDirectoryRecursive "secrets" >> try @IOError (renameDirectory "secrets_" "secrets"))
    $ do
        sHandle <- mkServerHandle
        withCardanoServer sHandle $ do
            Server.spec