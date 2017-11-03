module Main where

import Prelude

import Control.Monad.Aff (launchAff_)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import CuriPodcastProxy.Server (serve)
import Network.HTTP.Affjax (AJAX)
import Node.HTTP (HTTP)
import Node.Process (PROCESS)

main :: forall e. Eff (console :: CONSOLE, http :: HTTP, process :: PROCESS, ajax :: AJAX | e) Unit
main = do
  launchAff_ serve
