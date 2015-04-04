
module Gidl.Backend.Ivory.Unpack where

import Data.List (intercalate)
import Ivory.Artifact

unpackModule :: [String] -> Artifact
unpackModule modulepath =
  artifactPath (intercalate "/" modulepath) $
  artifactString "Unpack.hs" $
  unlines
    [ ""
    , "{-# LANGUAGE DataKinds #-}"
    , "{-# LANGUAGE RankNTypes #-}"
    , "{-# LANGUAGE ScopedTypeVariables #-}"
    , ""
    , "module " ++ (intercalate "." modulepath) ++ ".Unpack where"
    , ""
    , "import Ivory.Language"
    , "import Ivory.Serialize"
    , "import Ivory.Stdlib"
    , ""
    , "unpackWithCallback :: forall n a s1 s2 r b s0"
    , "                    . (ANat n, IvorySizeOf a, IvoryArea a, IvoryZero a, Packable a)"
    , "                   => ConstRef s1 (Array n (Stored Uint8))"
    , "                   -> Ref s2 (Stored Uint32)"
    , "                   -> (ConstRef (Stack s0) a -> Ivory ('Effects r b (Scope s0)) ())"
    , "                   -> Ivory ('Effects r b (Scope s0)) ()"
    , "unpackWithCallback arr offs k = do"
    , "  o <- deref offs"
    , "  let sufficient_remaining = ((o + fromIntegral (packSize (packRep :: PackRep a))) <?"
    , "                               arrayLen arr)"
    , "  when sufficient_remaining $ do"
    , "    v <- local izero"
    , "    unpackFrom arr o v"
    , "    offs += fromInteger (packSize (packRep :: PackRep a))"
    , "    k (constRef v)"
    ]