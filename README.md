# CSE 6633 WordleBot

This repo is for all files related to the MSU CSE 6633 AI group project. 

### WordleBot

Our bot was written in Swift, which can be run with XCode on a Mac. 
You can find it in the WordleBot/WordleBot folder. The main bot code is found in WordleBot.swift. 

First, you will see the BotSettings private struct. This is so that we can adjust individual settings in the Bot and run the loop again. The description of each setting is provided.

Second, the main loop function is "autoPlay()." It first sets up the bot based on the settings, then begins playing once you get to the "repeat" loop. There are two repeat loops. The outer loop is to loop through multiple word sets. The inner loop is to loop through every possible game defined in the NYT source code. 

The way the bot plays is to load the dictionary of possible words into its "profile" of the target word. It will guess a word based on the provided settings and update the known information about the target word. It will use that information to filter down the list of possible words. The bot will then select another word to guess and proceed in this fashion until it wins or plays 6 words without winning.

Please note: Our WordleBot does not have 100% win rate! The win rate will vary by its strategy settings.

### WordProfiler

WordProfiler is a utility to create a profile of every word in the dictionary based on the 5-word & 3-word sets. This was for human-researcher benefit. It allowed us to see the effect size of words which had the same profile. The profiles this utility generated were used in an early version of our Bot, but were deprecated as we refactored and improved the Bot's codebase. Additionally, seeing the effect size of word choice helped us hypothesize the most valuable strategies for word choice to incorporate into WordleBot.

### WordleParser

The WordleParser was a utility built when our project scope included Quordle. Once the scope changed, this utility was deprecated in value, but it should still work to parse an image posted on Twitter into an emoji text string.
The SwiftImage library used in this utility is pulled from here: https://github.com/koher/swift-image v.0.7.

### Other folders

* "letter-position-data" is the letter-position frequency data. It has its own readme. This data is incorporated into WordleBot as one of its strategies for selecting a word to play.
* "game-dictionaries" are pulled from the source code of Wordle & Quordle, before the former was removed from the frontend by NYT and when the latter was in scope of our research project.
* "sample-word-profiles" is the output from WordProfiler. 
* "word-frequencies" is the data for frequency of usage of the dictionary. This data is incorporated into WordleBot as one of its strategies for selecting a word to play.

