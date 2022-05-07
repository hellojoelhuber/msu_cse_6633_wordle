
// This view is from an early iteration when we were testing a little bit manually. We also used this view to record a demonstration of how the both guesses using different methods.

// This view is deprecated due to a refactor of how the game and bot code works, but is left here for its historical value and possible resurrection in the future.

////
////  WordleGameView.swift
////  wordleGame
////
////  Created by Joel Huber on 4/16/22.
////
//
//import SwiftUI
//
//struct WordleGameView: View {
//    @ObservedObject var wordleGame = WordleGameViewController()
//
//    var body: some View {
//        VStack {
//            VStack {
////                wordleGuess(guess: wordleGame.guesses()[0].guess)
////                wordleGuess(guess: wordleGame.guesses()[1].guess)
////                wordleGuess(guess: wordleGame.guesses()[2].guess)
////                wordleGuess(guess: wordleGame.guesses()[3].guess)
////                wordleGuess(guess: wordleGame.guesses()[4].guess)
////                wordleGuess(guess: wordleGame.guesses()[5].guess)
//            }
//            Spacer()
//
////            Text("Remaining Possible Words: \(wordleGame.remainingPossibleWords())")
//
//            VStack {
//                Spacer()
//
//                autoGuess
//
//                Spacer()
//
//                nextGuess
//
//                Spacer()
//
////                guessByFrequency
//
//                Spacer()
//            }
//
//        }
//    }
//
//
//    var autoGuess: some View {
//        Button("auto guess") {
////            wordleGame.autoguess()
//        }
//    }
//
//
//    var nextGuess: some View {
//        Button("Next Guess in Sequence") {
////            wordleGame.guessWord()
//        }
//    }
////    var guessByFrequency: some View {
////        Button("Guess by Frequency: \(wordleGame.lastWordByFreq())") {
////            wordleGame.guessByFrequency()
////        }
////        .disabled(wordleGame.countOfGuesses() < 5)
////    }
//
//}
//
//struct wordleGuess: View {
//    let guess: [GuessResult]
//
//    var body: some View {
//        HStack {
//            letterBox(letter: guess[0].guessedLetter,
//                      boxColor: guess[0].guessedResult)
//            letterBox(letter: guess[1].guessedLetter,
//                      boxColor: guess[1].guessedResult)
//            letterBox(letter: guess[2].guessedLetter,
//                      boxColor: guess[2].guessedResult)
//            letterBox(letter: guess[3].guessedLetter,
//                      boxColor: guess[3].guessedResult)
//            letterBox(letter: guess[4].guessedLetter,
//                      boxColor: guess[4].guessedResult)
//        }
//    }
//}
//
//struct letterBox: View {
//    let letter: String?
//    let boxColor: squareStatus
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 4, style: .circular)
//                .foregroundColor(boxColor.stateColor())
//                .frame(width: 50, height: 50)
//
//            Text(letter ?? "").foregroundColor(.white)
//        }
//    }
//}
//
////struct WordleGameView_Previews: PreviewProvider {
////    static var previews: some View {
////        wordleGameView()
////    }
////}
