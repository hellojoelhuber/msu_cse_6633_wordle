//
//  WordleGame.swift
//  WordleBot
//
//  Created by Joel Huber on 4/25/22.
//

import Foundation

struct WordleGame {
    private let wordOfTheDay: String
    private var guessedWords = [String]()
    private var guessResults: [[squareStatus]] = []
    private var isComplete = false
    private var isWin = false
    
    func getGuessedWords() -> [String] {
        guessedWords
    }
    func getGuessResults() -> [[squareStatus]] {
        guessResults
    }
    func getLastResult() -> [squareStatus] {
        guessResults.last ?? []
    }
    func getIsWin() -> Bool {
        isWin
    }
    func getIsComplete() -> Bool {
        isComplete
    }
    
    init(wordOfTheDay: String) {
        self.wordOfTheDay = wordOfTheDay
    }
    
    mutating func guess(word: String) {
        if !isComplete {
            guessedWords.append(word)
            guessResults.append(calcGuessResult(word: word))
            isWin = checkWinCondition(guessResult: guessResults.last!)
            isComplete = guessedWords.count == 6
        }
    }
    
    private func calcGuessResult(word: String) -> [squareStatus] {
        var guessResult = [squareStatus]()
        
        for index in 0..<word.count {
            if word[index] == wordOfTheDay[index] {
                guessResult.append(.correct)
            } else if wordOfTheDay.contains(word[index]) {
                guessResult.append(.wrongPosition)
            } else {
                guessResult.append(.wrongLetter)
            }
        }
        
        return guessResult
    }
    private func checkWinCondition(guessResult: [squareStatus]) -> Bool {
        for result in guessResult {
            if result != .correct {
                return false
            }
        }
        return true
    }
}

