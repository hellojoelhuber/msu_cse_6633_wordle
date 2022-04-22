//
//  WordleBotViewController.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

class WordleBotViewController: ObservableObject {
    @Published var wordleBot: WordleBot
    private func guessSequence() -> [String] {
        wordleBot.guessSequence
    }
    func countOfGuesses() -> Int {
        wordleBot.guesses.count
    }
    private let emptyGuessWord = GuessWord(guess: [GuessResult(guessedLetter: "",guessedResult: .unguessed),
                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
                                           GuessResult(guessedLetter: "",guessedResult: .unguessed),
                                           GuessResult(guessedLetter: "",guessedResult: .unguessed)])
    
    func guesses() -> [GuessWord] {
        var guesses = wordleBot.guesses
        while guesses.count < 6 {
            guesses.append(emptyGuessWord)
        }
        return guesses
    }
    func remainingPossibleWords() -> Int {
        wordleBot.remainingPossibleWords()
    }
    func lastWordByFreq() -> String {
        if countOfGuesses() < 5 {
            return "Too many guesses left."
        }
        return wordleBot.guessByWordFrequency()
    }
    
    func guessWord() {
        if countOfGuesses() < 5 {
            wordleBot.guess(word: guessSequence()[countOfGuesses()])
        } else {
            let word = wordleBot.guessByProfile()
            wordleBot.guess(word: word)
        }
    }
    func guessByFrequency() {
        let word = wordleBot.guessByWordFrequency()
        wordleBot.guess(word: word)
    }
    func autoguess() {
        wordleBot.autoplay()
    }
    
    
    init() {
        wordleBot = WordleBot.init()
    }
}


enum squareStatus {
    case correct
    case wrongPosition
    case wrongLetter
    case unguessed
    
    func stateColor() -> Color {
        switch self {
        case .correct:
            return Color.green
        case .unguessed:
            return Color.gray.opacity(0.65)
        case .wrongLetter:
            return Color.secondary
        case .wrongPosition:
            return Color.yellow
        }
    }
}
