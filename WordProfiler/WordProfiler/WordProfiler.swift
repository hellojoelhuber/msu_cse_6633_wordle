//
//  WordProfiler.swift
//  WordProfiler
//
//  Created by Joel Huber on 4/6/22.
//

import Foundation


struct WordProfiler {
    static let set25_1 = WordSet(name: "set25a",
                                 words: ["glent", "brick", "jumpy", "vozhd", "waqfs"])
    static let set25_2 = WordSet(name: "set25b",
                                 words: ["waqfs", "vozhd", "grypt", "clunk", "bemix"])
    static let set24_1 = WordSet(name: "set24a",
                                 words: ["fixed", "grown", "jambs", "klutz", "psych"])
    static let set24_2 = WordSet(name: "set24b",
                                 words: ["fjord", "glyph", "mucks", "vixen", "waltz"])
    static let set24_3 = WordSet(name: "set24c",
                                 words: ["clunk", "fritz", "glyph", "jambs", "vowed"])
    static let set23_1 = WordSet(name: "set23a",
                                 words: ["bunch", "fjord", "glitz", "twerk", "vamps"])
    static let set23_2 = WordSet(name: "set23b",
                                 words: ["brunt", "flock", "gawps", "jived", "myths"])
    static let set23_3 = WordSet(name: "set23c",
                                 words: ["drift", "jocks", "lymph", "swung", "zebra"])
    static let set23_4 = WordSet(name: "set23d",
                                 words: ["gifts", "jumbo", "nymph", "velds", "wrack"])
    static let set23_5 = WordSet(name: "set23e",
                                 words: ["barfs", "codex", "junks", "lymph", "wight"])
    let knownPositions = [1,2,3,4,5]
    var allWordSets = [set25_1, set25_2,
                       set24_1, set24_2, set24_3,
                       set23_1, set23_2, set23_3, set23_4, set23_5]
    var profiles: [WordProfile] = []
    
    static let alphabet = "abcdefghijklmnopqrstuvwxyz"
    
    let sampleWords = ["brake", "pluck", "craze", "gripe", "weary", "picky", "acute"]
    let similarWords = ["steal", "teals", "slate", "stale", "tales", "least"]
    let nyt_words = NYT_Dict.init().dictionary
    
    
    mutating func iterateAllWordSets() {
        print("NYT Dict is \(nyt_words.count) entries long.")
        for wordSet in allWordSets {
            iterateLesserWordSets(wordSet: wordSet)
        }
    }
    
    // NOTE: Create arrays of the words in the word sets, refactor the iterateAllWordSets to create the wordset from the array in the loop.
    mutating func iterateLesserWordSets(wordSet: WordSet) {
        var combinationsOfWords: [[String]] = []
        var includeWordInSet = [false,false,false,false,false]
        var tempWords: [String] = []
        repeat {
            for index in 0..<includeWordInSet.count {
                if includeWordInSet[index] {
                    includeWordInSet[index] = !includeWordInSet[index]
                } else {
                    includeWordInSet[index] = !includeWordInSet[index]
                    break
                }
            }
            
            for index in 0..<includeWordInSet.count {
                if includeWordInSet[index] {
                    tempWords.append(wordSet.words[index])
                }
            }
            combinationsOfWords.append(tempWords)
            tempWords = []
        } while (!isArrayTrue(array: includeWordInSet))
        combinationsOfWords = combinationsOfWords.sorted(by: { $0.count < $1.count })

        var counter = 0
        var prevWordCount = 0
        for words in combinationsOfWords {
            if prevWordCount == words.count {
                counter += 1
            } else {
                counter = 1
            }
            prevWordCount = words.count
            
            profiles = []
            let name = "\(wordSet.name)_words\(words.count)_loop\(counter)"
            
            var tempWordSet = WordSet(name: name,
                                      words: words)
            iterateDictionary(basedOn: tempWordSet)
            tempWordSet.profiles = profiles

            tempWordSet.countProfiles = countProfiles(in: tempWordSet)
            tempWordSet.countUniqueProfiles = countUniqueProfiles(in: tempWordSet)

            let fileName = "wordle_profiles_" + tempWordSet.name + ".json"
            exportJson(fileName: fileName, json: tempWordSet)
        }
    }
    
    func isArrayTrue(array: [Bool]) -> Bool {
        for index in 0..<array.count {
            if !array[index] {
                return false
            }
        }
        return true
    }
    
    mutating func iterateDictionary(basedOn wordSet: WordSet) {
        for word in nyt_words {
            var profile = createWordProfile(for: word, basedOn: wordSet)
            let profileIndex = findMatchingProfile(test: profile)
            if (profileIndex < profiles.count) {
                profiles[profileIndex].words.append(word)
            } else {
                profile.words.append(word)
                profiles.append(profile)
            }
        }
    }
    // TASK: Refactor this to create profile based on a single guess, not all 5 guesses.
    func createWordProfile(for word: String, basedOn wordSet: WordSet) -> WordProfile {
        var profile = WordProfile(includedLetters: [],
                                  knownPositions: [:],
                                  words: [])
        
        // NOTE: I'm cheating here. I am enforcing no repeated letters because none of the word sets we chose have duplicate letters. For example, if we chose a word set with the word "shush", then we could identify repeated s and repeated h. But our careful word choices means I can enforce this assumption here.
        for char in word {
            let isNewLetter: Bool = profile.includedLetters.firstIndex(of: String(char)) == nil ? true : false
            let isNotMissing: Bool = wordSet.missingLetters.firstIndex(of: String(char)) == nil ? true : false
            if (isNewLetter) && (isNotMissing) {
                profile.includedLetters.append(String(char))
            }
        }
        profile.includedLetters.sort()
        
        for position in knownPositions {
            let index = position - 1
            for comparator in wordSet.words {
                if comparator[index] == word[index] {
                    profile.knownPositions[knownPositions[index]] = String(word[index])
                }
            }
        }
        
        return profile
    }
    
    func printProfile(_ profile: WordProfile) {
        print("Included Letters:\t \(profile.includedLetters)")
        print("Known Positions: \t \(profile.knownPositions)")
        print("Matching Words:  \t \(profile.words)")
        print("\n")
    }
    
    func findMatchingProfile(test: WordProfile) -> Int {
        for example in 0..<profiles.count {
            if profiles[example] == test {
                return example
            }
        }
        return profiles.count
    }
    func compareProfiles(left: WordProfile, right: WordProfile) -> Bool {
        if (left == right) {
            return true
        }
        return false
    }
    mutating func countProfiles(in wordSet: WordSet) -> Int {
        wordSet.profiles.count
    }
    mutating func countUniqueProfiles(in wordSet: WordSet) -> Int {
        var counter = 0
        
        for profile in profiles {
            if profile.words.count == 1 {
                counter += 1
            }
        }
        
        return counter
    }
    
    func exportJson(fileName: String, json: WordSet) {
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
        var alphabet = WordProfiler.alphabet
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
//    var knownPositions: KnownPositions
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



extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
