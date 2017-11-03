module CuriPodcastProxy.Env where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Int (fromString)
import Data.Maybe (Maybe)
import Node.Process (PROCESS, lookupEnv)


getPort :: forall eff. Eff (process :: PROCESS | eff) (Maybe Int)
getPort = do
    mEnv <- lookupEnv "PORT"
    pure $ join $ fromString <$> mEnv
