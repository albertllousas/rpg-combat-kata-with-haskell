module RpgCombatSpec where

import Character
import NonCharacter
import Attack
import Faction
import Healing
import Test.Hspec

spec :: Spec
spec = do

  describe "All Characters, when created" $ do

    it "should have health, starting at 1000, level, starting at 1, Alive and belonging to no Faction" $ do
      let newCharacter = Character { name="Cersei Lannister", health = 1000, level = 1 , typeOfFighter = Melee, factions = [] }
      createCharacter "Cersei Lannister" Melee `shouldBe` newCharacter

    it "should be Alive or Dead, starting Alive" $ do
      isAlive (createCharacter "Sansa Stark" Melee) `shouldBe` True

  describe "Deal Damage" $ do

    it "should subtract damage from health of the target" $ do
      let aryaStark = createCharacter "Arya Stark" Melee
      let theHound = createCharacter "The Hound" Melee
      dealDamage aryaStark (meleeAttack 100) theHound `shouldBe` Right theHound { health = 900 }

    it "should kill a character when damage received exceeds current health" $ do
      let jonSnow = createCharacter "Jon Snow" Melee
      let nightKing = createCharacter "Night King" Melee
      let damagedNightKing = dealDamage jonSnow (meleeAttack 10000) nightKing
      damagedNightKing `shouldBe` Right nightKing { health = 0 }
      isAlive <$> damagedNightKing `shouldBe` Right False

    it "should not deal damage to itself" $ do
      let eddStark = createCharacter "Edd Stark" Melee
      dealDamage eddStark (meleeAttack 100) eddStark `shouldBe` (Left CanNotDealDamageToItself)

    it "should decrease the damage by 50% when the target is 5 or more levels above the attacker" $ do
      let jonSnow = createCharacter "Jon Snow" Melee
      let nightKing = Character { name="Jon Snow", health = 1000, level = 15, typeOfFighter = Melee, factions = []  }
      let damagedNightKing = dealDamage jonSnow (meleeAttack 1000) nightKing
      damagedNightKing `shouldBe` Right nightKing { health = 500 }

    it "should increase the damage by 50% when the target is 5 or more levels below the attacker" $ do
      let jonSnow = Character { name="Jon Snow", health = 1000, level = 20, typeOfFighter = Melee, factions = []  }
      let nightKing = Character { name="Night King", health = 1000, level = 10, typeOfFighter = Melee, factions = []  }
      let damagedNightKing = dealDamage jonSnow (meleeAttack 100) nightKing
      damagedNightKing `shouldBe` Right nightKing { health = 850 }

    it "characters must be in range to deal damage to a target" $ do
      let jonSnow = createCharacter "Jon Snow" Melee
      let nightKing = createCharacter "Night King" Melee
      dealDamage jonSnow (Attack 100 10) nightKing `shouldBe` Left OutOfRange

    it "melee characters can deal damage in a bigger distance" $ do
      let jonSnow = createCharacter "Jon Snow" Ranged
      let nightKing = createCharacter "Night King" Melee
      dealDamage jonSnow (Attack 100 10) nightKing `shouldBe` Right nightKing { health = 900 }

    it "Allies cannot deal damage to one another" $ do
      let jonSnow = Character { name="Jon Snow", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
      let aryaStark = Character { name="Arya Stark", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
      dealDamage jonSnow (Attack 100 10) aryaStark `shouldBe` Left CanNotDealDamageToAnAlly

    it "Characters can damage non-character things" $ do
      let jonSnow = createCharacter "Jon Snow" Ranged
      let tree = NonCharacter "Tree" 2000
      dealDamageNonCharacter jonSnow 500 tree `shouldBe` NonCharacter "Tree" 1500

  describe "Attack range" $ do

    it "melee fighters have a range of 2 meters" $ do
      attackMaxRange Melee `shouldBe` 2

    it "ranged fighters have a range of 20 meters" $ do
      attackMaxRange Ranged `shouldBe` 20

  describe "Factions" $ do

    it "a character may Join one or more factions" $ do
      let jonSnow = createCharacter "Jon Snow" Melee
      jonSnow `joinFaction` "Night's Watch" `shouldBe` jonSnow { factions = ["Night's Watch"] }

    it "a character may Leave one or more factions" $ do
      let jonSnow = Character { name="Jon Snow", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Night's Watch", "Winterfell"]  }
      jonSnow `leaveFaction` "Winterfell" `shouldBe` jonSnow { factions = ["Night's Watch"] }

    it "players belonging to the same faction are considered allies" $ do
      let jonSnow = Character { name="Jon Snow", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
      let aryaStark = Character { name="Arya Stark", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
      jonSnow `isAlly` aryaStark `shouldBe` True

    it "players that don't belong to the same faction are not considered allies" $ do
      let jonSnow = Character { name="Jon Snow", health = 1, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
      let nightKing = Character { name="NightKing", health = 1, level = 20, typeOfFighter = Melee, factions = ["White Walkers"]  }
      jonSnow `isAlly` nightKing `shouldBe` False


  describe "Healing" $ do

    it "a character can not heal another character" $ do
      let jonSnow = Character { name="Jon Snow", health = 100, level = 10, typeOfFighter = Melee, factions = []  }
      let branStark = createCharacter "Bran Stark" Melee
      branStark `heal` jonSnow `shouldBe` Left CharacterCanNotBeHealed

    it "a character can heal itself" $ do
      let jonSnow = Character { name="Jon Snow", health = 100, level = 10, typeOfFighter = Melee, factions = []  }
      jonSnow `heal` jonSnow `shouldBe` Right jonSnow { health = 1000 }

    it "allies can heal one another" $ do
       let jonSnow = Character { name="Jon Snow", health = 1000, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
       let aryaStark = Character { name="Arya Stark", health = 100, level = 20, typeOfFighter = Melee, factions = ["Winterfell"]  }
       jonSnow `heal` aryaStark `shouldBe` Right aryaStark { health = 1000 }

    it "healing cannot raise health above 1000" $ do
      let branStark = Character { name="Bran Stark", health = 1000, level = 10, typeOfFighter = Melee, factions = []  }
      branStark `heal` branStark `shouldBe` Right branStark { health = 1000 }

  describe "Non-Characters" $ do

    it "when reduced to 0 Health, things are Destroyed" $ do
      isDestroyed (NonCharacter "Tree" 0) `shouldBe` True


