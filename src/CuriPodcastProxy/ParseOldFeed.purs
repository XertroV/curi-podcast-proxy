module CuriPodcastProxy.ParseOldFeed where


import Prelude

import Data.String.Yarn (words, unwords, unlines, lines)


replaceAmpersand :: String -> String
replaceAmpersand str = if str == "&" then "&amp;" else str


scanAndReplace :: String -> String
scanAndReplace fullFeed = process fullFeed
    where
        process :: String -> String
        process = unlines <<< liftA1 procLine <<< lines
        procLine :: String -> String
        procLine = unwords <<< (liftA1 replaceAmpersand) <<< words
