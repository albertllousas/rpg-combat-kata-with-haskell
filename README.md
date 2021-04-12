# rpg-combat-kata-with-haskell

[RPG Combat Kata](https://github.com/ardalis/kata-catalog/blob/master/katas/RPG%20Combat.md) in haskell.

## The problem to solve

```spel
Iteration One
  1. All Characters, when created, have:
    ❍ Health, starting at 1000
    ❍ Level, starting at 1
    ❍ May be Alive or Dead, starting Alive (Alive may be a true/false)
  2. Characters can Deal Damage to Characters.
    ❍ Damage is subtracted from Health
    ❍ When damage received exceeds current Health, Health becomes 0 and the character dies
  3. A Character can Heal a Character.
    ❍ Dead characters cannot be healed
    ❍ Healing cannot raise health above 1000
Iteration Two
  1. A Character cannot Deal Damage to itself.
  2. A Character can only Heal itself.
  3. When dealing damage:
    ❍ If the target is 5 or more Levels above the attacker, Damage is reduced by 50%
    ❍ If the target is 5 or more levels below the attacker, Damage is increased by 50%
Iteration Three
  1. Characters have an attack Max Range.
  2. Melee fighters have a range of 2 meters.
  3. Ranged fighters have a range of 20 meters.
  4. Characters must be in range to deal damage to a target.
Iteration Four
  1. Characters may belong to one or more Factions.
    ❍ Newly created Characters belong to no Faction.
  2. A Character may Join or Leave one or more Factions.
  3. Players belonging to the same Faction are considered Allies.
  4. Allies cannot Deal Damage to one another.
  5. Allies can Heal one another.
Iteration Five
  1. Characters can damage non-character things (props).
    ❍ Anything that has Health may be a target
    ❍ These things cannot be Healed and they do not Deal Damage
    ❍ These things do not belong to Factions; they are neutral
    ❍ When reduced to 0 Health, things are Destroyed
    ❍ As an example, you may create a Tree with 2000 Health
```

## The solution

[Here](/test/RpgCombatSpec.hs), the tests.

[Here](/src/), the solution.

## Run tests
```shell
stack test
```
```shell
RpgCombat
  All Characters, when created
    should have health, starting at 1000, level, starting at 1, Alive and belonging to no Faction
    should be Alive or Dead, starting Alive
  Deal Damage
    should subtract damage from health of the target
    should kill a character when damage received exceeds current health
    should not deal damage to itself
    should decrease the damage by 50% when the target is 5 or more levels above the attacker
    should increase the damage by 50% when the target is 5 or more levels below the attacker
    characters must be in range to deal damage to a target
    melee characters can deal damage in a bigger distance
    Allies cannot deal damage to one another
    Characters can damage non-character things
  Attack range
    melee fighters have a range of 2 meters
    ranged fighters have a range of 20 meters
  Factions
    a character may Join one or more factions
    a character may Leave one or more factions
    players belonging to the same faction are considered allies
    players that don't belong to the same faction are not considered allies
  Healing
    a character can not heal another character
    a character can heal itself
    allies can heal one another
    healing cannot raise health above 1000
  Non-Characters
    when reduced to 0 Health, things are Destroyed

Finished in 0.0017 seconds
22 examples, 0 failures
```
