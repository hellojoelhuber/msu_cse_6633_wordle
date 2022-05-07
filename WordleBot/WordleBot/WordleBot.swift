//
//  WordleBot.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import Foundation

struct WordleBot {
    private struct BotSettings {
        let unluckiestBotInTheWorld: Bool // always guesses wrongly if given a choice.
        
        let perfectMemory: Bool // true == bot can remember past words
        let answersSortedByFrequency: Bool // true == This will sort the answers by frequency DESC so that the bot will never play a higher-frequency word out-of-order, so to speak.
        let totalCheater: Bool // true == uses the answer dictionary as the set of possible words
        let frequencyCheater: Bool // true == uses the dictionary with lowest frequency answer & higher as set of possible words; roughly 1/2 the complete dictionary.

        let guessMethodFrequency: Bool // true == use the highest Frequency possible word as guess
        let seekKnowledge: Bool // if included letter count is less than limit, play a word consisting of unplayed letters.
        let limitCountIncludedLetters: Int // the included letter count limit

        let lengthOfSequence: Int // length of sub-sequences. Set to 3 for 3-word sequences.
//        let onRails: Bool // refers to the 5-word sequences
        let oneLoop: Bool // Loop through all combinations, or only 1 loop through combos?
        
        // These two settings are for the special research-paper set of words.
        let specialGame: Bool
        let specialGameWords = ["raise", "clout", "nymph"]
    }
    private let settings: BotSettings

    // TASK: Need to code in a score-keeper to compare results between otherwise similar bots.
    
//    private var wordOfTheDay: String
    
    var memoryOfPastWords = [String]()
    let knownPositions = [1,2,3,4,5]
    var totalGames = 0
    var winCounter = 0
    
//    init(wordOfTheDay: String) {
//        self.wordOfTheDay = wordOfTheDay
    init() {
        self.settings = BotSettings(unluckiestBotInTheWorld: false,
                                    
                                    perfectMemory: true,
                                    answersSortedByFrequency: false,
                                    totalCheater: false,
                                    frequencyCheater: false,

                                    guessMethodFrequency: true,
                                    seekKnowledge: true,
                                    limitCountIncludedLetters: 4,

                                    lengthOfSequence: 5,
//                                    onRails: true,
                                    oneLoop: true,

                                    specialGame: false
        )
    }
    
    mutating func autoplay() {
        let wordSets = [ ["glent", "brick", "jumpy", "vozhd", "waqfs"],
                         ["waqfs", "vozhd", "grypt", "clunk", "bemix"],
                         ["fixed", "grown", "jambs", "klutz", "psych"],
                         ["fjord", "glyph", "mucks", "vixen", "waltz"],
                         ["clunk", "fritz", "glyph", "jambs", "vowed"],
                         ["bunch", "fjord", "glitz", "twerk", "vamps"],
                         ["brunt", "flock", "gawps", "jived", "myths"],
                         ["drift", "jocks", "lymph", "swung", "zebra"],
                         ["gifts", "jumbo", "nymph", "velds", "wrack"],
                         ["barfs", "codex", "junks", "lymph", "wight"] ]
        
        let answers = convertStringsCSVIntoArray(filename: "answers")
        let dictionaryOfAllWords = convertStringsCSVIntoArray(filename: "combinedDictionary")
        
        var cheatersDictionary = [String]()
        if (settings.frequencyCheater) {
            let filename = "dict_freq.json"
            var dictionaryFrequency = DictFreq(entry: [:])
            if let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) {
                do {
                    // Getting data from JSON file using the file URL
                    let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                    dictionaryFrequency = parseDictionaryFrequency(json: data)
                } catch {
                    // Handle error here
                }
            }
            
            let minimumFrequency = dictionaryFrequency.entry["geeky"] ?? 0.0000002834628
            
            for word in dictionaryOfAllWords {
                let frequencyOfWord = dictionaryFrequency.entry[word] ?? 0
                if frequencyOfWord >= minimumFrequency {
                    cheatersDictionary.append(word)
                }
            }
        }
        
        let answerCount = answers.count
        totalGames = answerCount
        
        // onRails
        var innerLoopCounter = 0
        
        func generateWordSubset() -> [[String]] {
            var subsets = [[String]]()
            var includeWordInSet = [false,false,false,false,false]
            
            repeat {
                var tempWords = [String]()
                
                // Loop to generate every combination of words from the word sets.
                // If the index is true, flip to false; otherwise set to true and break the loop.
                // Loop 1: [T,F,F,F,F]; Loop 2: [F, T, F,F,F]; Loop 3: [T, T, F,F,F] etc.
                for index in 0..<includeWordInSet.count {
                    if includeWordInSet[index] {
                        includeWordInSet[index] = !includeWordInSet[index]
                    } else {
                        includeWordInSet[index] = !includeWordInSet[index]
                        break
                    }
                }
                
                // TASK: Extend array to tell me the count of trues
                var countOfTrue = 0
                for index in 0..<includeWordInSet.count {
                    if includeWordInSet[index] { countOfTrue += 1 }
                }
                
                if countOfTrue == settings.lengthOfSequence {
                    for index in 0..<includeWordInSet.count {
                        if includeWordInSet[index] {
                            tempWords.append(wordSets[outerLoopCounter][index])
                        }
                    }
                    
                    subsets.append(tempWords)
                }
            } while (!includeWordInSet.allTrue)
            
            return subsets
        }
        
        var outerLoopCounter = 0
        // if outerLoopCounter > 0, then we are looping through multiple word sets.
        repeat {
            // Subsets of word sets
            var combinationsOfWords: [[String]] = []
            combinationsOfWords = generateWordSubset()
            
            
            var gameResults = [GameResult]()
            innerLoopCounter = 0
            
            // Loop through all the answers for a given word set.
            repeat {
                var countOfWinningGames = 0
                var answerSequence = [String]()
                memoryOfPastWords = []
                var guessSequence = [String]()

                // breaks the repeat-loop if the combinationsOfWords equals the loop counter AND the onRails setting is false.
                if (combinationsOfWords.count == innerLoopCounter) {
                    break
                }

                // Load the guess sequence
                if settings.specialGame {
                    guessSequence = settings.specialGameWords
                }
//                else if settings.onRails {
//                    guessSequence = wordSets[outerLoopCounter]
//                }
                else {
                    guessSequence = combinationsOfWords[innerLoopCounter]
                }
                print(guessSequence)
                
                // This loads the answer set in official or frequency order.
                if settings.answersSortedByFrequency {
                    answerSequence = sortDictionaryByFrequency(answersOnly: true)
                } else {
                    answerSequence = answers
                }
                
                // ***********
                // THIS IS WHERE THE ACTUAL GAME IS BEING PLAYED
                // ***********
                for wotd in answerSequence {
                    var game = WordleGame(wordOfTheDay: wotd)
                    
                    var profileOfWOTD: WordProfile = WordProfile(includedLetters: [],
                                                                 knownPositions: [:],
                                                                 words: [])
                    // Load the dictionary into the profileOfWOTD
                    if settings.frequencyCheater {
                        profileOfWOTD.loadProfileOfWOTDWords(with: cheatersDictionary)
                    } else if settings.totalCheater {
                        profileOfWOTD.loadProfileOfWOTDWords(with: answers)
                    } else {
                        profileOfWOTD.loadProfileOfWOTDWords(with: dictionaryOfAllWords)
                    }
                    // should perfectMemory remove memoryOfPastWords during loop initialization or leave its check in the functions which call it?
                    // if perfectMemory { }
                                        
                    // The guess loop
                    repeat {
                        let guessCounter = game.getGuessedWords().count
                        var word = String()
                        
                        // HOW TO SELECT A WORD TO GUESS
                        // brute force
                        if (profileOfWOTD.words.count) <= (6 - guessCounter) {
                            word = profileOfWOTD.words[0]
                        }
                        // Sequence
                        else if guessCounter < guessSequence.count {
                            word = guessSequence[guessCounter]
                        }
                        // seek knowledge
                        else if settings.seekKnowledge && (profileOfWOTD.includedLetters.count < settings.limitCountIncludedLetters) {
                            word = guessByPosition(remainingWords: profileOfWOTD.words, guessedWords: game.getGuessedWords())
                        }
                        // Frequency
                        else if (settings.guessMethodFrequency) {
                            word = guessByWordFrequency(remainingWords: profileOfWOTD.words)
                        }
                        // random guessing
                        else {
                            word = profileOfWOTD.words.randomElement()!
                        }
                        
                        game.guess(word: word)
                        profileOfWOTD.updateProfileWOTD(word: word, result: game.getLastResult())
                        profileOfWOTD.removeWordsFromProfileWOTD(basedOn: word)
                        
                        // This bit of code was added in an early iteration, either to paper over a bug or as a cautionary measure. It is unclear, at this point, which it was nor what removing the code would do, so it remains until I have time to investigate further.
                        if wotd != word {
                            if let indexOfWord = profileOfWOTD.words.firstIndex(of: word) {
                                profileOfWOTD.words.remove(at: indexOfWord)
                            }
                        }

                    } while (!game.getIsComplete())
                    
                    if (game.getIsWin()) { countOfWinningGames += 1 }
                    gameResults.append(GameResult(wordToGuess: wotd,
                                                  guessedWords: game.getGuessedWords(),
                                                  result: game.getIsWin()))
                    if settings.perfectMemory { memoryOfPastWords.append(wotd) }
                }
                print("\(guessSequence) won \(countOfWinningGames) out of \(answerCount).")
                exportGameResults(fileName: "\(guessSequence)-game-results.json", json: gameResults)
                
                innerLoopCounter += 1
                winCounter = countOfWinningGames
            } while (innerLoopCounter < wordSets.count)
            outerLoopCounter += 1
        } while (outerLoopCounter < wordSets.count && !settings.oneLoop)
    }
    
    func sortDictionaryByFrequency(answersOnly: Bool) -> [String] {
        let filename = "dict_freq.json"
        var dictionaryFrequency = DictFreq(entry: [:])
        if let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                dictionaryFrequency = parseDictionaryFrequency(json: data)
            } catch {
                // Handle error here
            }
        }
        
        let answers = convertStringsCSVIntoArray(filename: "answers")
        var answersSorted = [String]()
        for word in dictionaryFrequency.entry.sorted(by: { $0.value > $1.value } ) {
            if answersOnly && answers.contains(word.key) {
                answersSorted.append(word.key)
            } else if !answersOnly {
                answersSorted.append(word.key)
            }
        }
        
        return answersSorted
    }
    
    func parseDictionaryFrequency(json: Data) -> DictFreq {
        let decoder = JSONDecoder()
        let jsonTweets = try? decoder.decode(DictFreq.self, from: json)
        return jsonTweets ?? DictFreq(entry: ["none":0])
    }
    func guessByWordFrequency(remainingWords: [String]) -> String {
        let filename = "dict_freq.json"
        var dictionaryFrequency = DictFreq(entry: [:])
        if let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                dictionaryFrequency = parseDictionaryFrequency(json: data)
            } catch {
                // Handle error here
            }
        }

        var currentWord = remainingWords[0]
        for word in remainingWords {
            if (dictionaryFrequency.entry[word] ?? 0) > (dictionaryFrequency.entry[currentWord] ?? 0) {
                if !settings.perfectMemory {
                    currentWord = word
                } else {
                    if !memoryOfPastWords.contains(word) {
                        currentWord = word
                    }
                }
            }
        }
        
        return currentWord
    }
    
    func convertLetterPositionCSVIntoArray(hasHeader: Bool) -> [[Int]] {
        var letterFrequency: [[Int]] = []
        
        //locate the file you want to use
        guard let filepath = Bundle.main.path(forResource: "letter_pos_count_large_sample", ofType: "csv") else {
            return []
        }
        
        //convert that file into one long string
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print(error)
            return []
        }
        
        //now split that string into an array of "rows" of data.  Each row is a string.
        var rows = data.components(separatedBy: "\n")
        
        //if you have a header row, remove it here
        if (hasHeader) {
            rows.removeFirst()
        }
        
        //now loop around each row, and split it into each of its columns
        for row in rows {
            let columns = row.components(separatedBy: ",")
            //check that we have enough columns
            if columns.count == 27 {
                let pos = Int(columns[0]) ?? 0
                let a = Int(columns[1]) ?? 0
                let b = Int(columns[2]) ?? 0
                let c = Int(columns[3]) ?? 0
                let d = Int(columns[4]) ?? 0
                let e = Int(columns[5]) ?? 0
                let f = Int(columns[6]) ?? 0
                let g = Int(columns[7]) ?? 0
                let h = Int(columns[8]) ?? 0
                let i = Int(columns[9]) ?? 0
                let j = Int(columns[10]) ?? 0
                let k = Int(columns[11]) ?? 0
                let l = Int(columns[12]) ?? 0
                let m = Int(columns[13]) ?? 0
                let n = Int(columns[14]) ?? 0
                let o = Int(columns[15]) ?? 0
                let p = Int(columns[16]) ?? 0
                let q = Int(columns[17]) ?? 0
                let r = Int(columns[18]) ?? 0
                let s = Int(columns[19]) ?? 0
                let t = Int(columns[20]) ?? 0
                let u = Int(columns[21]) ?? 0
                let v = Int(columns[22]) ?? 0
                let w = Int(columns[23]) ?? 0
                let x = Int(columns[24]) ?? 0
                let y = Int(columns[25]) ?? 0
                let z = Int(columns[26]) ?? 0
                
                let frequencies = [pos, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]
//                let frequencies = LetterPosition(pos: pos, a: a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i, j: j, k: k, l: l, m: m, n: n, o: o, p: p, q: q, r: r, s: s, t: t, u: u, v: v, w: w, x: x, y: y, z: z)
                letterFrequency.append(frequencies)
            }
        }
        return letterFrequency
    }
    func guessByPosition(remainingWords: [String], guessedWords: [String]) -> String {
        let letterFrequency = convertLetterPositionCSVIntoArray(hasHeader: true)
        let letterValue = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10, "k": 11, "l": 12, "m": 13, "n": 14, "o": 15, "p": 16, "q": 17, "r": 18, "s": 19, "t": 20, "u": 21, "v": 22, "w": 23, "x": 24, "y": 25, "z": 26]
        
        var guessedLetters: [String] = []
        for word in guessedWords {
            var tempGuessedLetters = guessedLetters
            for char in word {
                if tempGuessedLetters.contains(String(char)) {
                    tempGuessedLetters.remove(at: tempGuessedLetters.firstIndex(of: String(char))!)
                } else {
                    guessedLetters.append(String(char))
                }
            }
        }
        
        var currentWord = ""
        var currentValue = -1
        for word in remainingWords {
            var tempValue = 0
            var tempGuessedLetters = guessedLetters
            for index in 0..<word.count {
                if tempGuessedLetters.contains(String(word[index])) {
                    tempGuessedLetters.remove(at: tempGuessedLetters.firstIndex(of: String(word[index]))!)
                } else {
                    let letterIndex = letterValue[String(word[index])]
                    tempValue += letterFrequency[index][letterIndex!]
                }
            }
            
            if settings.perfectMemory {
                if memoryOfPastWords.contains(word) {
                    tempValue = 0
                }
            }
            
            if tempValue > currentValue {
                currentValue = tempValue
                tempValue = 0
                currentWord = word
            }
        }
        
        return currentWord
    }
    
    func exportGameResults(fileName: String, json: [GameResult]) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(fileName)

            print("File URL should be: \(fileURL)")
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            try encoder.encode(json)
                .write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func convertStringsCSVIntoArray(filename: String) -> [String] {
        //locate the file you want to use
        guard let filepath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            return []
        }
        
        //convert that file into one long string
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print(error)
            return []
        }
        
        let rows = data.components(separatedBy: "\n")
            
        let columns = rows[0].components(separatedBy: ",")
        
        return columns
    }
    
    // NOTE: This function was designed to tell the number of games where choosing the word by frequency, assuming the games were sorted by word frequency, would result in a loss. It was simply to prove a point to us, the researcher, that the "dog wouldn't hunt." As a function, it is deprecated because necessary pieces to make it function have been refactored out of the project. The function remains here, commented out, for posterity.
    // If you really, really, really want to make it run, though, you can use git and find an older commit that preserves the necessary pieces.
//    func evaluateThePlausibilityOfPerfectFrequencyGames() {
//        var testProfiles: WordSet = WordSet(name: "", words: [])
//        var sortedAnswers = sortDictionaryByFrequency(answersOnly: true)
//        var sortedDictionary = sortDictionaryByFrequency(answersOnly: false)
//
//        for profile in profilesFromFile.profiles {
//            if profile.words.count == 1 {
//                if sortedAnswers.contains(profile.words[0]) {
//                    sortedAnswers.remove(at: sortedAnswers.firstIndex(of: profile.words[0])!)
//                }
//                sortedDictionary.remove(at: sortedDictionary.firstIndex(of: profile.words[0])!)
//            }
//            if profile.words.count > 1 {
//                testProfiles.profiles.append(profile)
//            }
//        }
//
//        for profile in testProfiles.profiles {
//            var tempAnswers = [String]()
//            var tempDictionary = [String]()
//
//            for word in sortedDictionary {
//                for index in 0..<profile.words.count {
//                    if profile.words[index] == word {
//                        tempDictionary.append(word)
//                        if sortedAnswers.contains(word) {
//                            tempAnswers.append(word)
//                        }
//                    }
//                }
//            }
//
//
//            for word in tempAnswers {
//                if tempDictionary[0] == word {
//                    tempDictionary.remove(at: 0)
//                } else {
//                    repeat {
//                        print("Dictionary \(tempDictionary[0]), and \(tempAnswers.contains(tempDictionary[0])), so probably lose on game \(word)")
//                        tempDictionary.remove(at: 0)
//                    } while (tempDictionary[0] != word)
//                    tempDictionary.remove(at: 0)
//                }
//            }
//        }
//
//    }
}

struct DictFreq: Codable {
    var entry: [String:Double]
}

struct GameResult: Codable {
    var wordToGuess: String
    var guessedWords: [String]
    var result: Bool
}

struct WordProfile: Equatable, Codable {
    var includedLetters: [String]
    var knownPositions: [Int:String]
    var words: [String]
    
    static func ==(lhs: WordProfile, rhs: WordProfile) -> Bool {
        return (lhs.includedLetters == rhs.includedLetters &&
                lhs.knownPositions == rhs.knownPositions)
    }
    
    mutating func updateProfileWOTD(word: String, result: [squareStatus]) {
        for index in 0..<word.count {
            if result[index] == .correct {
                self.includedLetters.append(String(word[index]))
                self.knownPositions[index + 1] = String(word[index])
            } else if result[index] == .wrongPosition {
                self.includedLetters.append(String(word[index]))
            }
        }
        self.includedLetters.sort()
    }
    
    // TASK: Refactor this to use the word & result from the WordleGame struct.
    // TASK: Review algo to see if we can combine the checks into 1 loop per word. May need to consider what the fastest way to exclude a word and then refactor, if possible.
    mutating func removeWordsFromProfileWOTD(basedOn word: String) {
        var newDictionary = self.words
        var dictionaryCount = newDictionary.count
        var tempIncludedLetters = self.includedLetters
        let countOfIncludedLetters = self.includedLetters.count
        
        // Remove words that do not have a letter in a known position.
        for index in 0..<dictionaryCount {
            let word = dictionaryCount - index - 1
            for letter in self.knownPositions {
                if String(newDictionary[word][letter.key - 1]) != letter.value {
                    newDictionary.remove(at: word)
                    break
                }
            }
        }
        
        // Remove words that do not contain letters that we know are included.
        dictionaryCount = newDictionary.count
        for index in 0..<dictionaryCount {
            let word = dictionaryCount - index - 1
            tempIncludedLetters = self.includedLetters
            for letterIndex in 0..<countOfIncludedLetters {
                let letter = countOfIncludedLetters - letterIndex - 1
                if String(newDictionary[word]).contains(self.includedLetters[letter]) {
                    tempIncludedLetters.remove(at: letter)
                } else {
                    newDictionary.remove(at: word)
                    break
                }
            }
        }
        
        // Remove words that DO contain letters in positions we know they are not.
        var falsePositions: [Int:String] = [:]
        if self.knownPositions[1] == nil {
            falsePositions[1] = String(word[0]) }
        if self.knownPositions[2] == nil {
            falsePositions[2] = String(word[1]) }
        if self.knownPositions[3] == nil {
            falsePositions[3] = String(word[2]) }
        if self.knownPositions[4] == nil {
            falsePositions[4] = String(word[3]) }
        if self.knownPositions[5] == nil {
            falsePositions[5] = String(word[4]) }
        
        dictionaryCount = newDictionary.count
        for index in 0..<dictionaryCount {
            let word = dictionaryCount - index - 1
            for letter in falsePositions {
                if String(newDictionary[word][letter.key - 1]) == letter.value {
                    newDictionary.remove(at: word)
                    break
                }
            }
        }
        
        // This logic check is vestigial code from an early version of the bot when we had a concern that this function could errantly remove the solution. This never happened in the life of the function, so it is being commented out but left in the codebase for posterity.
//        if (!newDictionary.contains(wordOfTheDay)) {
//            print("WARNING!!! \(wordOfTheDay) was eliminated!!!")
//        }
        
        self.words = newDictionary
    }
    
    mutating func loadProfileOfWOTDWords(with providedDictionary: [String]) {
        self.words = providedDictionary
    }
}

struct LetterPosition {
    var pos: Int
    var a: Int
    var b: Int
    var c: Int
    var d: Int
    var e: Int
    var f: Int
    var g: Int
    var h: Int
    var i: Int
    var j: Int
    var k: Int
    var l: Int
    var m: Int
    var n: Int
    var o: Int
    var p: Int
    var q: Int
    var r: Int
    var s: Int
    var t: Int
    var u: Int
    var v: Int
    var w: Int
    var x: Int
    var y: Int
    var z: Int
}
