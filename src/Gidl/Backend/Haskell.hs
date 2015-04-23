module Gidl.Backend.Haskell where

import Gidl.Schema
import Gidl.Interface
import Gidl.Backend.Cabal
import Gidl.Backend.Haskell.Types
import Gidl.Backend.Haskell.Test
import Gidl.Backend.Haskell.Interface

import Ivory.Artifact

import Data.Char (isSpace)
import Data.List (nub)
import Text.PrettyPrint.Mainland

haskellBackend :: [Interface] -> String -> String -> [Artifact]
haskellBackend iis pkgname namespace_raw =
  [ cabalFileArtifact cf
  , makefile
  , artifactPath "tests" serializeTestMod
  ] ++
  [ artifactPath "src" m | m <- sourceMods
  ]
  where
  types = nub [ t | i <- iis, t <- interfaceTypes i]
  tmods = [ typeModule False (namespace ++ ["Types"]) t
          | t <- types
          , isUserDefined t
          ]
  imods = [ interfaceModule False (namespace ++ ["Interface"]) i
          | i <- iis
          ]
  sourceMods = tmods ++ imods
  cf = (defaultCabalFile pkgname cabalmods deps) { tests = [ serializeTest ] }
  cabalmods = [ filePathToPackage (artifactFileName m) | m <- sourceMods ]
  deps = [ "cereal", "QuickCheck" ]

  serializeTest = defaultCabalTest "serialize-test" "SerializeTest.hs"
                      (pkgname:deps)
  serializeTestMod = serializeTestModule namespace iis

  namespace = dotwords namespace_raw


  dotwords :: String -> [String]
  dotwords s = case dropWhile isDot s of
    "" -> []
    s' -> let  (w, s'') = break isDot s' in w : dotwords s''
  isDot c = (c == '.') || isSpace c

makefile :: Artifact
makefile = artifactText "Makefile" $
  prettyLazyText 1000 $ stack
    [ text "default:"
    , text "\tcabal build"
    , empty
    , text "create-sandbox:"
    , text "\tcabal sandbox init"
    , text "\tcabal install --enable-tests --dependencies-only"
    , empty
    , text "test:"
    , text "\tcabal test"
    , empty
    ]

