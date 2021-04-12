module Faction where

import Character
import Data.List

joinFaction :: Character -> Faction -> Character
joinFaction character faction = character { factions = newFactions }
    where currentFactions = factions character
          newFactions = if faction `elem` currentFactions then currentFactions else faction : currentFactions

leaveFaction :: Character -> Faction -> Character
leaveFaction character faction = character { factions = newFactions }
    where newFactions = filter (\a -> a /= faction ) (factions character)

isAlly :: Character -> Character -> Bool
isAlly c1 c2 = if (length (intersect (factions c1) (factions c2)) > 0) then True else False