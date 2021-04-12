{-# OPTIONS_GHC -Werror=incomplete-patterns #-}
module Attack where

import Faction
import Character
import NonCharacter

type Damage = Int
type Distance = Int
type Attacker = Character
type Target = Character
data Attack = Attack Damage Distance

meleeAttack :: Damage -> Attack
meleeAttack damage = Attack damage 1

data DealDamageFailure = CanNotDealDamageToItself | OutOfRange | CanNotDealDamageToAnAlly deriving (Show, Eq)

dealDamage :: Attacker -> Attack -> Target -> Either DealDamageFailure Target
dealDamage attacker (Attack damage distance) target | attacker == target = Left CanNotDealDamageToItself
                                                    | areAllies = Left CanNotDealDamageToAnAlly
                                                    | isOutOfRange = Left OutOfRange
                                                    | isTarget5LevelsAboveAttacker = Right $ attack damageDecreasedBy50Percent
                                                    | isTarget5LevelsBelowAttacker = Right $ attack damageIncreasedBy50Percent
                                                    | otherwise = Right $ attack damage
  where attack = \finalDamage ->  target { health = applyDamage finalDamage (health target) }
        applyDamage = \d h -> if h - d < 0 then 0 else h - d
        isTarget5LevelsAboveAttacker = (level attacker - level target) < -5
        isTarget5LevelsBelowAttacker = (level target - level attacker) < -5
        damageDecreasedBy50Percent = damage `div` 2
        damageIncreasedBy50Percent = damage + damageDecreasedBy50Percent
        isOutOfRange = attackMaxRange (typeOfFighter attacker) < distance
        areAllies = attacker `isAlly` target

dealDamageNonCharacter :: Attacker -> Damage -> NonCharacter -> NonCharacter
dealDamageNonCharacter attacker damage (NonCharacter t h) = NonCharacter t (applyDamage damage h)
    where applyDamage = \d h -> if h - d < 0 then 0 else h - d