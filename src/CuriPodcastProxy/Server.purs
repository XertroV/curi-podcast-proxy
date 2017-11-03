module CuriPodcastProxy.Server where

import Prelude

import Control.Monad.Aff (Aff, error, throwError, liftEff')
import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, throwException)
import CuriPodcastProxy.Const (podcastURL)
import CuriPodcastProxy.Env (getPort)
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..), maybe)
import Network.HTTP.Affjax (AJAX, affjax, defaultRequest, get)
import Node.HTTP (HTTP)
import Node.Process (PROCESS)
import QuickServe (GET, quickServe)


getFeed :: forall eff. Aff (ajax :: AJAX, console :: CONSOLE | eff) (String)
getFeed = do
    resp <- get podcastURL
    log $ "Got back: " <> resp.response
    pure $ resp.response


serve :: forall eff. Aff (console :: CONSOLE, http :: HTTP, process :: PROCESS, ajax :: AJAX | eff) Unit
serve = do 
    portM <- liftEff' $ getPort
    port <- maybe (throwError $ error "Unable to get PORT env var") (\p -> pure p) portM
    let opts = {hostname: "localhost", port: port, backlog: Nothing}
    liftEff $ quickServe opts proxy
        where
            proxy :: GET (console :: CONSOLE, process :: PROCESS, ajax :: AJAX | eff) String
            proxy = do
                liftAff $ log "Got request for feed"
                content <- liftAff $ getFeed
                liftAff $ log $ "Got feed: " <> content
                pure content
