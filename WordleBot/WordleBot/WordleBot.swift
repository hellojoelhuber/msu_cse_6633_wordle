//
//  WordleBot.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import Foundation



struct WordleBot {
    let perfectMemory = true
    let guessMethodology = true // true == Profile
    let guessMethodFrequency = true
    let unluckiestBotInTheWorld = false
    let onRails = true
    let oneLoop = false
    let debugging = false
    let seekingKnowledge = true
    let lengthOfSequence = 1
//    let limitIncludedLetters = true
    let limitCountIncludedLetters = 4
//    let limitKnownPositions = false
//    let limitCountKnownPositions = 1
    let totalCheater = false
    let frequencyCheater = false
    let specialGame = false
    let specialGameWords = ["raise", "clout", "nymph"]
    let answersSortedByFrequency = false
    
    // TASK: Need to code in a score-keeper to compare results between otherwise similar bots.
    
    private var wordOfTheDay = "cigar"
    var guessSequence = ["bunch","fjord","glitz","twerk","vamps"]
    var guesses: [GuessWord] = []
    var profileOfWOTD: WordProfile = WordProfile(includedLetters: [],
                                                 knownPositions: [:],
                                                 words: [])
    var gameResults: [GameResult] = []
    var profilesFromFile: WordSet = WordSet(name: "", words: [])
    var memoryOfPastWords: [String] = []
    let knownPositions = [1,2,3,4,5]
    
    init() {
        let filename = "wordle_profiles_set23a_words5_loop1.json"
        profilesFromFile = loadWordSetFromFile(filename: filename)
        loadProfileOfWOTDWords(with: nil)
    }
    func isArrayTrue(array: [Bool]) -> Bool {
        for index in 0..<array.count {
            if !array[index] {
                return false
            }
        }
        return true
    }
  
    func evaluateThePlausibilityOfPerfectFrequencyGames() {
        var testProfiles: WordSet = WordSet(name: "", words: [])
        var sortedAnswers = sortDictionaryByFrequency(answersOnly: true)
        var sortedDictionary = sortDictionaryByFrequency(answersOnly: false)
        
        for profile in profilesFromFile.profiles {
            if profile.words.count == 1 {
                if sortedAnswers.contains(profile.words[0]) {
                    sortedAnswers.remove(at: sortedAnswers.firstIndex(of: profile.words[0])!)
                }
                sortedDictionary.remove(at: sortedDictionary.firstIndex(of: profile.words[0])!)
            }
            if profile.words.count > 1 {
                testProfiles.profiles.append(profile)
            }
        }
        
        for profile in testProfiles.profiles {
            var tempAnswers = [String]()
            var tempDictionary = [String]()
            
            for word in sortedDictionary {
                for index in 0..<profile.words.count {
                    if profile.words[index] == word {
                        tempDictionary.append(word)
                        if sortedAnswers.contains(word) {
                            tempAnswers.append(word)
                        }
                    }
                }
            }
            
            
            for word in tempAnswers {
                if tempDictionary[0] == word {
                    tempDictionary.remove(at: 0)
                } else {
                    repeat {
                        print("Dictionary \(tempDictionary[0]), and \(tempAnswers.contains(tempDictionary[0])), so probably lose on game \(word)")
                        tempDictionary.remove(at: 0)
                    } while (tempDictionary[0] != word)
                    tempDictionary.remove(at: 0)
                }
            }
        }
        
    }
    
    mutating func loadProfileOfWOTDWords(with providedDictionary: [String]?) {
        profileOfWOTD.words = providedDictionary ?? convertStringsCSVIntoArray(filename: "combinedDictionary")
    }
    
    mutating func autoplay() {
        let fileNames = ["wordle_profiles_set23a_words5_loop1.json",
                         "wordle_profiles_set23b_words5_loop1.json",
                         "wordle_profiles_set23c_words5_loop1.json",
                         "wordle_profiles_set23d_words5_loop1.json",
                         "wordle_profiles_set23e_words5_loop1.json",
                         "wordle_profiles_set24a_words5_loop1.json",
                         "wordle_profiles_set24b_words5_loop1.json",
                         "wordle_profiles_set24c_words5_loop1.json",
                         "wordle_profiles_set25a_words5_loop1.json",
                         "wordle_profiles_set25b_words5_loop1.json"]
        let answers = convertStringsCSVIntoArray(filename: "answers")
        let dictionaryOfAllWords = convertStringsCSVIntoArray(filename: "combinedDictionary")
        
        var cheatersDictionary: [String] = []
        if (frequencyCheater) {
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
            print("Our dictionary has \(cheatersDictionary.count) words.")
        }
        
        var counter = 0
        var loopCounter = 0
        var countOfWinningGames = 0
        let answerCount = answers.count
        
        // onRails
        var filesProcessed = 0
        
        // 3 words
        var combinationsOfWords: [[String]] = []
        var includeWordInSet = [false,false,false,false,false]
        if !onRails {
            var tempWords: [String] = []
            repeat {
                // loops through the includeWordInSet [Bool] and flips bools accordingly.
                for index in 0..<includeWordInSet.count {
                    if includeWordInSet[index] {
                        includeWordInSet[index] = !includeWordInSet[index]
                    } else {
                        includeWordInSet[index] = !includeWordInSet[index]
                        break
                    }
                }
                
                var countOfTrue = 0
                for index in 0..<includeWordInSet.count {
                    if includeWordInSet[index] { countOfTrue += 1 }
                }
                
                if countOfTrue == lengthOfSequence {
                    for index in 0..<includeWordInSet.count {
                        if includeWordInSet[index] {
                            tempWords.append(guessSequence[index])
                        }
                    }
                    
                    combinationsOfWords.append(tempWords)
                }
                
                
                tempWords = []
            } while (!isArrayTrue(array: includeWordInSet))
        }
        
        repeat {
            if loopCounter > 0 {
                combinationsOfWords = []
                includeWordInSet = [false,true,true,false,false]
                guessSequence = loadWordSetFromFile(filename: fileNames[loopCounter]).words
                
            
                var tempWords: [String] = []
                repeat {
                    // loops through the includeWordInSet [Bool] and flips bools accordingly.
                    for index in 0..<includeWordInSet.count {
                        if includeWordInSet[index] {
                            includeWordInSet[index] = !includeWordInSet[index]
                        } else {
                            includeWordInSet[index] = !includeWordInSet[index]
                            break
                        }
                    }
                    
                    var countOfTrue = 0
                    for index in 0..<includeWordInSet.count {
                        if includeWordInSet[index] { countOfTrue += 1 }
                    }
                    
                    if countOfTrue == lengthOfSequence {
                        for index in 0..<includeWordInSet.count {
                            if includeWordInSet[index] {
                                tempWords.append(guessSequence[index])
                            }
                        }
                        
                        combinationsOfWords.append(tempWords)
                    }
                    
                    tempWords = []
                } while (!isArrayTrue(array: includeWordInSet))
            }
            filesProcessed = 0
            gameResults = []
            
            repeat {
                if !onRails && (combinationsOfWords.count <= filesProcessed) {
                    break
                }
                // Load the guess sequence
                if specialGame {
                    guessSequence = specialGameWords
                }
                else if onRails {
                    profilesFromFile = loadWordSetFromFile(filename: fileNames[filesProcessed])
                    guessSequence = profilesFromFile.words
                }
                else {
                    guessSequence = combinationsOfWords[filesProcessed]
                }
                print(guessSequence)
                
                counter = 0
                countOfWinningGames = 0
                memoryOfPastWords = []
                var answerSequence = [String]()
                if answersSortedByFrequency {
                    answerSequence = sortDictionaryByFrequency(answersOnly: true)
                } else {
                    answerSequence = answers
                }
                
                for wotd in answerSequence {
                    var sequenceEndingResultString = ""
                    self.wordOfTheDay = wotd
                    profileOfWOTD.knownPositions = [:]
                    profileOfWOTD.includedLetters = []
                    if frequencyCheater {
                        loadProfileOfWOTDWords(with: cheatersDictionary)
                    } else if totalCheater {
                        loadProfileOfWOTDWords(with: answers)
                    } else {
                        loadProfileOfWOTDWords(with: dictionaryOfAllWords)
                    }
                    // should perfectMemory remove memoryOfPastWords during loop initialization or leave its check in the functions which call it?
                    // if perfectMemory { }
                    
                    guesses = []
                    var gameResult = GameResult(wordToGuess: wotd, guessedWords: [], result: false)
                    
                    
                    repeat {
                        let guessCounter = guesses.count
                        
                        // brute force
                        if (profileOfWOTD.words.count) <= (6 - guessCounter) {
                            let word = profileOfWOTD.words[0]
                            guess(word: word)
                            gameResult.guessedWords.append(word)
                            removeWordsFromProfileWOTD(basedOn: word)
                            if wotd != word {
                                if let indexOfWord = profileOfWOTD.words.firstIndex(of: word) {
                                    profileOfWOTD.words.remove(at: indexOfWord)
                                }
                            }
                        }
                        
                        // Sequence
                        else if guessCounter < guessSequence.count {
                            let word = guessSequence[guessCounter]
                            guess(word: word)
                            gameResult.guessedWords.append(word)
                            removeWordsFromProfileWOTD(basedOn: word)
                            
                            if debugging {
                                if (guesses.count == guessSequence.count) {
                                    sequenceEndingResultString = "Ending \(guessSequence) | Included | \(profileOfWOTD.includedLetters.count) | Known | \(profileOfWOTD.knownPositions.count) | Possible Words | \(profileOfWOTD.words.count) | WOTD | \(wotd) | Result | "
                                }
                            }
                        }
                        
                        // seek knowledge
                        else if seekingKnowledge && (profileOfWOTD.includedLetters.count < limitCountIncludedLetters) {
                            let word = guessByPosition(guessedWords: gameResult.guessedWords)
                            guess(word: word)
                            gameResult.guessedWords.append(word)
                            removeWordsFromProfileWOTD(basedOn: word)
                            if wotd != word {
                                if let indexOfWord = profileOfWOTD.words.firstIndex(of: word) {
                                    profileOfWOTD.words.remove(at: indexOfWord)
                                }
                            }
                        }
                        
                        // Frequency
                        else if (guessMethodFrequency) {
                            let word = guessByWordFrequency()
                            guess(word: word)
                            gameResult.guessedWords.append(word)
                            removeWordsFromProfileWOTD(basedOn: word)
                            if wotd != word {
                                if let indexOfWord = profileOfWOTD.words.firstIndex(of: word) {
                                    profileOfWOTD.words.remove(at: indexOfWord)
                                }
                            }
                        }
                        
                        // random guessing
                        else {
                            let word = profileOfWOTD.words.randomElement()!
                            guess(word: word)
                            gameResult.guessedWords.append(word)
                            removeWordsFromProfileWOTD(basedOn: word)
                            if wotd != word {
                                if let indexOfWord = profileOfWOTD.words.firstIndex(of: word) {
                                    profileOfWOTD.words.remove(at: indexOfWord)
                                }
                            }
                        }
                        
                        
                    } while (wotd != gameResult.guessedWords.last)
                    
                    
//                    if onRails {
//                        // I should refator this as guessProfileWord = GuessMethod() w/ getter-setter property
//                        var guessProfileWord = ""
//                        if guessMethodology {
//                            guessProfileWord = guessByProfile()
//                        } else {
//                            guessProfileWord = guessByWordFrequency()
//                        }
//                        guess(word: guessProfileWord)
//                        gameResult.guessedWords.append(guessProfileWord)
//                    }
        
                    gameResult.result = gameResult.guessedWords.last == wotd
                    if (gameResult.result) { countOfWinningGames += 1 }
                    gameResults.append(gameResult)
                    if perfectMemory { memoryOfPastWords.append(wotd) }
                    
                    counter += 1
                    
                    if debugging { print("\(sequenceEndingResultString)\(gameResult.result)") }
                }
                print("\(guessSequence) won \(countOfWinningGames) out of \(answerCount).")
                exportGameResults(fileName: "\(guessSequence)-game-results.json", json: gameResults)
                
                filesProcessed += 1
            } while (filesProcessed < fileNames.count)
            loopCounter += 1
        } while (!onRails && loopCounter < fileNames.count && !oneLoop)
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
    
    mutating func guess(word: String) {
        var currentGuess = GuessWord(guess: [])
        var counter = 0
        for char in word {
            if char == wordOfTheDay[counter] {
                currentGuess.guess.append(GuessResult(guessedLetter: String(char).uppercased(),
                                                      guessedResult: .correct))
                if (!profileOfWOTD.includedLetters.contains(String(char))) {
                    profileOfWOTD.includedLetters.append(String(char))
                }
                profileOfWOTD.knownPositions[counter + 1] = String(char)
            } else if wordOfTheDay.contains(char) {
                currentGuess.guess.append(GuessResult(guessedLetter: String(char).uppercased(),
                                                      guessedResult: .wrongPosition))
                if (!profileOfWOTD.includedLetters.contains(String(char))) {
                    profileOfWOTD.includedLetters.append(String(char))
                }
            } else {
                currentGuess.guess.append(GuessResult(guessedLetter: String(char).uppercased(),
                                                      guessedResult: .wrongLetter))
            }
            counter += 1
        }
        guesses.append(currentGuess)
        profileOfWOTD.includedLetters.sort()
    }
    
    mutating func removeWordsFromProfileWOTD(basedOn word: String) {
        var newDictionary = profileOfWOTD.words
        var dictionaryCount = newDictionary.count
        var tempIncludedLetters = profileOfWOTD.includedLetters
        let countOfIncludedLetters = profileOfWOTD.includedLetters.count
        
        // Remove words that do not have a letter in a known position.
        for index in 0..<dictionaryCount {
            let word = dictionaryCount - index - 1
            for letter in profileOfWOTD.knownPositions {
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
            tempIncludedLetters = profileOfWOTD.includedLetters
            for letterIndex in 0..<countOfIncludedLetters {
                let letter = countOfIncludedLetters - letterIndex - 1
                if String(newDictionary[word]).contains(profileOfWOTD.includedLetters[letter]) {
                    tempIncludedLetters.remove(at: letter)
                } else {
                    newDictionary.remove(at: word)
                    break
                }
            }
        }
        
        // Remove words that DO contain letters in positions we know they are not.
        var falsePositions: [Int:String] = [:]
        if profileOfWOTD.knownPositions[1] == nil {
            falsePositions[1] = String(word[0]) }
        if profileOfWOTD.knownPositions[2] == nil {
            falsePositions[2] = String(word[1]) }
        if profileOfWOTD.knownPositions[3] == nil {
            falsePositions[3] = String(word[2]) }
        if profileOfWOTD.knownPositions[4] == nil {
            falsePositions[4] = String(word[3]) }
        if profileOfWOTD.knownPositions[5] == nil {
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
        
        if (!newDictionary.contains(wordOfTheDay)) {
            print("WARNING!!! \(wordOfTheDay) was eliminated!!!")
        }
        
                
        profileOfWOTD.words = newDictionary
    }
    
    mutating func loadWordSetFromFile(filename: String) -> WordSet {
        if let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return parseWordProfiles(json: data)
            } catch {
                // Handle error here
            }
        }
        return WordSet(name: "", words: [])
    }
    func parseWordProfiles(json: Data) -> WordSet {
        let decoder = JSONDecoder()
        let jsonTweets = try? decoder.decode(WordSet.self, from: json)
        return jsonTweets!
    }
    func guessByProfile() -> String {
        let remainingWords = findMatchingProfile(test: profileOfWOTD).sorted()
        
        if unluckiestBotInTheWorld && remainingWords.count > 1 {
            return "waqfs"
        }
        
        if !perfectMemory {
            return remainingWords[0]
        } else {
            for word in remainingWords {
                if !memoryOfPastWords.contains(word) {
                    return word
                }
            }
        }
        return ""
    }
    
    func parseDictionaryFrequency(json: Data) -> DictFreq {
        let decoder = JSONDecoder()
        let jsonTweets = try? decoder.decode(DictFreq.self, from: json)
        return jsonTweets ?? DictFreq(entry: ["none":0])
    }
    func guessByWordFrequency() -> String {
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

        var remainingWords: [String] = []
        remainingWords = profileOfWOTD.words.sorted()

        var currentWord = remainingWords[0]
        for word in remainingWords {
            if (dictionaryFrequency.entry[word] ?? 0) > (dictionaryFrequency.entry[currentWord] ?? 0) {
                if !perfectMemory {
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
    func guessByPosition(guessedWords: [String]) -> String {
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
        for word in profileOfWOTD.words {
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
            
            if perfectMemory {
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
    
    func findMatchingProfile(test: WordProfile) -> [String] {
        for index in 0..<self.profilesFromFile.profiles.count {
            if self.profilesFromFile.profiles[index] == profileOfWOTD {
                return self.profilesFromFile.profiles[index].words
            }
        }
        
        return [""]
    }
    
//    func remainingPossibleWords() -> Int {
//        if (guesses.count == 0) { return 12947 }
//
//        var count = 0
//
//        for index in 0..<self.profilesFromFile.profiles.count {
//            if self.profilesFromFile.profiles[index] == profileOfWOTD {
//                count += self.profilesFromFile.profiles[index].words.count
//            }
//        }
//
//        return count
//    }
    
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
}

struct DictFreq: Codable {
    var entry: [String:Double]
}

struct GuessWord {
    var guess: [GuessResult]
}
struct GuessResult {
    var guessedLetter: String
    var guessedResult: squareStatus
}

struct GameResult: Codable {
    var wordToGuess: String
    var guessedWords: [String]
    var result: Bool
}

struct WordSet: Codable {
    var name: String
    var words: [String]
    var missingLetters: [String]
    var duplicateLetters: [String]
    var profiles: [WordProfile]
    var countProfiles: Int?
    var countUniqueProfiles: Int?
    
    init(name: String, words: [String]) {
        self.name = name
        self.words = words
        self.missingLetters = []
        self.duplicateLetters = []
        self.profiles = []
        identifyMissingAndDuplicateLetters(in: words)
    }
    
    mutating func identifyMissingAndDuplicateLetters(in words: [String]) {
        var alphabet = "abcdefghijklmnopqrstuvwxyz"
        var lettersInWords = ""
        var missingLetters: [String] = []
        var duplicateLetters: [String] = []
        
        for word in words {
            lettersInWords += word
        }
        
        for char in lettersInWords {
            if let indexOfLetter = alphabet.firstIndex(of: char) {
                alphabet.remove(at: indexOfLetter)
            } else {
                duplicateLetters.append(String(char))
            }
        }
        duplicateLetters.sort()
        
        for char in alphabet {
            missingLetters.append(String(char))
        }
        missingLetters.sort()
        
        self.duplicateLetters = duplicateLetters
        self.missingLetters = missingLetters
    }
}
struct WordProfile: Equatable, Codable {
    var includedLetters: [String]
    var knownPositions: [Int:String]
    var words: [String]
    
    static func ==(lhs: WordProfile, rhs: WordProfile) -> Bool {
        return (lhs.includedLetters == rhs.includedLetters &&
                lhs.knownPositions == rhs.knownPositions)
    }
}
struct KnownPositions: Equatable, Codable {
    var first: String?
    var second: String?
    var third: String?
    var fourth: String?
    var fifth: String?
    
    static func ==(lhs: KnownPositions, rhs: KnownPositions) -> Bool {
        return (lhs.first == rhs.first &&
                lhs.second == rhs.second &&
                lhs.third == rhs.third &&
                lhs.fourth == rhs.fourth &&
                lhs.fifth == rhs.fifth)
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


extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

