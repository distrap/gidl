
module Gidl.Types.Base
  ( uint8_t
  , uint16_t
  , uint32_t
  , uint64_t
  , sint8_t
  , sint16_t
  , sint32_t
  , sint64_t
  , bool_t
  , float_t
  , double_t
  , baseTypeEnv
  ) where

import Gidl.Types.AST

uint8_t  :: Type t
uint8_t  = AtomType (AtomWord Bits8)
uint16_t :: Type t
uint16_t = AtomType (AtomWord Bits16)
uint32_t :: Type t
uint32_t = AtomType (AtomWord Bits32)
uint64_t :: Type t
uint64_t = AtomType (AtomWord Bits64)

sint8_t  :: Type t
sint8_t  = AtomType (AtomInt  Bits8)
sint16_t :: Type t
sint16_t = AtomType (AtomInt  Bits16)
sint32_t :: Type t
sint32_t = AtomType (AtomInt  Bits32)
sint64_t :: Type t
sint64_t = AtomType (AtomInt  Bits64)

bool_t :: Type t
bool_t = EnumType (EnumT Bits8 [("false", 0), ("true", 1)])

float_t :: Type t
float_t = AtomType AtomFloat

double_t :: Type t
double_t = AtomType AtomDouble

baseTypeEnv :: TypeEnv
baseTypeEnv = TypeEnv
  [ ( "uint8_t" , uint8_t)
  , ( "uint16_t", uint16_t)
  , ( "uint32_t", uint32_t)
  , ( "uint64_t", uint64_t)
  , ( "sint8_t" , sint8_t)
  , ( "sint16_t", sint16_t)
  , ( "sint32_t", sint32_t)
  , ( "sint64_t", sint64_t)
  , ( "bool_t"  , bool_t)
  , ( "float_t" , float_t)
  , ( "double_t", double_t)
  ]

