module FakeProjects exposing (..)

type alias FakeProject =
  { name : String
  , category : String
  , description : String
  , link : String
  }

default : FakeProject
default =
  { name = ""
  , category = ""
  , description = ""
  , link = ""
  }

projects : List FakeProject
projects =
  List.map
    (\name ->
      { name = name
      , category = ""
      , description = ""
      , link = ""
      })
    (String.lines namesString)

namesString : String
namesString = """Twilight
Windmill
BusDriver
Hornet
PawPrint
OverClock
Cerberus
Bullring
Honey
Gator
Penguin
Alex
Spider
Coordinator
Elf
Vader
Skywalker
Yang
Nikola
Galaxy
Ink
Viper
Ampere
Lightbulb
FEET
Unicorn
MailMan
MapMixer
Femur
Fez
Logos
Basilisk
Mongoose
Cockatrice
Sheep
Ram
Bridge
Everest
Crystal
Warlock
Studfinder
Arae
Centaur
Cypress
Centrum
Stretch
Signal
VCR
Firehose
Peanut
Surf
Obsidian
Gondola
Wright
Xenon
Helium
Reception
Mole
Otter
Dory
Octopus
Katana"""
