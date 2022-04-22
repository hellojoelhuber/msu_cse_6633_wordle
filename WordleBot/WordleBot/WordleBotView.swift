//
//  ContentView.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

struct WordleBotView: View {
    @ObservedObject var wordleBot: WordleBotViewController = WordleBotViewController()
    
    var body: some View {
        VStack {
            VStack {
                wordleGuess(guess: wordleBot.guesses()[0].guess)
                wordleGuess(guess: wordleBot.guesses()[1].guess)
                wordleGuess(guess: wordleBot.guesses()[2].guess)
                wordleGuess(guess: wordleBot.guesses()[3].guess)
                wordleGuess(guess: wordleBot.guesses()[4].guess)
                wordleGuess(guess: wordleBot.guesses()[5].guess)
            }
            Spacer()
            
            Text("Remaining Possible Words: \(wordleBot.remainingPossibleWords())")
//            Text("Remaining Possible Words: 234234)")
            
            VStack {
                Spacer()
                
                autoGuess
                
                Spacer()
                
                nextGuess
                
                Spacer()
                
                guessByFrequency
                
                Spacer()
            }
            
        }
    }
    
    
    var autoGuess: some View {
        Button("auto guess") {
            wordleBot.autoguess()
        }
    }
    
    
    var nextGuess: some View {
        Button("Next Guess (Remaining: \(6-wordleBot.countOfGuesses()))") {
            wordleBot.guessWord()
        }
    }
    var guessByFrequency: some View {
        Button("\(wordleBot.lastWordByFreq())") {
            wordleBot.guessByFrequency()
        }
        .disabled(wordleBot.countOfGuesses() < 5)
    }
    
}

struct wordleGuess: View {
    let guess: [GuessResult]

    var body: some View {
        HStack {
            letterBox(letter: guess[0].guessedLetter,
                      boxColor: guess[0].guessedResult)
            letterBox(letter: guess[1].guessedLetter,
                      boxColor: guess[1].guessedResult)
            letterBox(letter: guess[2].guessedLetter,
                      boxColor: guess[2].guessedResult)
            letterBox(letter: guess[3].guessedLetter,
                      boxColor: guess[3].guessedResult)
            letterBox(letter: guess[4].guessedLetter,
                      boxColor: guess[4].guessedResult)
        }
    }
}

struct letterBox: View {
    let letter: String?
    let boxColor: squareStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .circular)
                .foregroundColor(boxColor.stateColor())
                .frame(width: 50, height: 50)
            
            Text(letter ?? "").foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordleBotView()
    }
}
