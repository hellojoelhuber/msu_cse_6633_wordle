//
//  WordleGameViewController.swift
//  WordleBot
//
//  Created by Joel Huber on 4/25/22.
//

import SwiftUI

// Commenting out the VC because no V is connected to it.

//class WordleGameViewController: ObservableObject {
//    @Published var wordleGame: WordleGame
//
//    init() {
//        wordleGame = WordleGame.init(wordOfTheDay: "cigar")
//    }
//}


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
