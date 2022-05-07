//
//  WordleBotViewController.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

class WordleBotViewController: ObservableObject {
    @Published var wordleBot: WordleBot
    func getTotalGames() -> Int {
        wordleBot.totalGames
    }
    func getWins() -> Int {
        wordleBot.winCounter
    }
    
    
//    private func guessSequence() -> [String] {
//        wordleBot.guessSequence
//    }
//    func countOfGuesses() -> Int {
//        wordleBot.guesses.count
//    }
//    private let emptyGuessWord = GuessWord(guess: [GuessResult(guessedLetter: "",guessedResult: .unguessed),
//                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
//                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
//                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
//                                           GuessResult(guessedLetter: "",guessedResult: .unguessed)])
//
//    func guesses() -> [GuessWord] {
//        var guesses = wordleBot.guesses
//        while guesses.count < 6 {
//            guesses.append(emptyGuessWord)
//        }
//        return guesses
//    }
//    func remainingPossibleWords() -> Int {
//        wordleBot.profileOfWOTD.words.count
//    }
//    func lastWordByFreq() -> String {
//        if countOfGuesses() < 5 {
//            return "Too many guesses left."
//        }
//        return wordleBot.guessByWordFrequency()
//    }
    
    func guessWord() {
//        if countOfGuesses() == 6 {
////            wordleBot = WordleBot.init(wordOfTheDay: "cigar")
//            wordleBot = WordleBot.init()
//        }
//        if countOfGuesses() < 5 {
//            let word = guessSequence()[countOfGuesses()]
//            wordleBot.guess(word: word)
//            wordleBot.removeWordsFromProfileWOTD(basedOn: word)
//        } else {
//            let word = wordleBot.guessByProfile()
//            wordleBot.guess(word: word)
//            wordleBot.removeWordsFromProfileWOTD(basedOn: word)
//        }
    }
    func guessByFrequency() {
//        let word = wordleBot.guessByWordFrequency()
//        wordleBot.guess(word: word)
    }
    func autoguess() {
        wordleBot.autoplay()
    }
    
    
    init() {
//        wordleBot = WordleBot.init(wordOfTheDay: "cigar")
        wordleBot = WordleBot.init()
    }
}

