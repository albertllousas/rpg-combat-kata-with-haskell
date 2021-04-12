module Healing where

import Character
import Faction

type Healer = Character
type Damaged = Character
type Healed = Character

data HealFailure = CharacterCanNotBeHealed deriving (Show, Eq)

heal :: Healer -> Damaged -> Either HealFailure Healed
heal healer damaged = if (healer == damaged) || healer `isAlly` damaged
                      then Right damaged { health = 1000 }
                      else Left CharacterCanNotBeHealed
