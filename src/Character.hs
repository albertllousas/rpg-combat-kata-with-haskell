module Character where

type Health = Int
type Level = Int
type Name = String
type Faction = String
data TypeOfFighter = Melee | Ranged deriving (Show, Eq)

attackMaxRange :: TypeOfFighter -> Int
attackMaxRange Melee = 2
attackMaxRange Ranged = 20

data Character = Character {
    name :: Name,
    health :: Health,
    level :: Level,
    typeOfFighter :: TypeOfFighter,
    factions :: [Faction]
} deriving (Show, Eq)

createCharacter :: Name -> TypeOfFighter -> Character
createCharacter name typeOfFighter = Character {
    name = name,
    health = 1000, level = 1,
    typeOfFighter =  typeOfFighter,
    factions = []
}

isAlive :: Character -> Bool
isAlive Character { health = h } = h > 0
