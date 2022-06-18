//
//  WordleBotViewController.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

class WordleBotViewController: ObservableObject {
    @Published var wordleBot: WordleBot? = nil
    
    func getTotalGames() -> Int {
        wordleBot?.totalGames ?? 0
    }
    
    func getWins() -> Int {
        wordleBot?.winCounter ?? 0
    }
    
    func initializeBot(unluckiestBotInTheWorld: Bool, perfectMemory: Bool, answersSortedByFrequency: Bool, totalCheater: Bool, frequencyCheater: Bool, guessMethodFrequency: Bool, seekKnowledge: Bool, limitCountIncludedLetters: Int, lengthOfSequence: Int, oneLoop: Bool, specialGame: Bool) {
        wordleBot = WordleBot.init(botSettings: WordleBot.BotSettings(unluckiestBotInTheWorld: unluckiestBotInTheWorld,
                                                                      perfectMemory: perfectMemory,
                                                                      answersSortedByFrequency: answersSortedByFrequency,
                                                                      totalCheater: totalCheater,
                                                                      frequencyCheater: frequencyCheater,
                                                                      guessMethodFrequency: guessMethodFrequency,
                                                                      seekKnowledge: seekKnowledge,
                                                                      limitCountIncludedLetters: limitCountIncludedLetters,
                                                                      lengthOfSequence: lengthOfSequence,
                                                                      oneLoop: oneLoop,
                                                                      specialGame: specialGame))
    }
    
    func autoguess() {
        wordleBot!.autoplay()
    }
    
    
    init() {
//        wordleBot = WordleBot.init(botSettings: nil)
    }
}

