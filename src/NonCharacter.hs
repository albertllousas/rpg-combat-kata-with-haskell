module NonCharacter where

type Health = Int
type NonCharacterType = String

data NonCharacter = NonCharacter NonCharacterType Health deriving (Show, Eq)

isDestroyed :: NonCharacter -> Bool
isDestroyed (NonCharacter _ h) = h <= 0