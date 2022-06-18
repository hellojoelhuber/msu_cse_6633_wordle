//
//  ContentView.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

struct WordleBotView: View {
    @ObservedObject var wordleBot: WordleBotViewController = WordleBotViewController()
    @State var unluckiestBotInTheWorld = false
    
    @State var guessMethodFrequency = false
    @State var perfectMemory = true
    
    @State var answersSortedByFrequency = false
    @State var totalCheater = false
    @State var frequencyCheater = false
    @State var seekKnowledge = true
    @State var limitCountIncludedLetters = 4
    @State var lengthOfSequence = 5
    @State var oneLoop = true
    @State var specialGame = false
    
    var body: some View {
        VStack {
            VStack {
                settings
                
                Spacer()
                
                Text("Won #\(wordleBot.getWins()) out of \(wordleBot.getTotalGames())")
            
                Spacer()
                
                initializeBot
                    .disabled(wordleBot.wordleBot != nil)
                
                autoGuess
                    .disabled(wordleBot.wordleBot == nil)
                
                Spacer()
            }
            
        }
    }
    
    var settings: some View {
        VStack {
            Stepper("Length of Seeded Sequence: \(lengthOfSequence)", value: $lengthOfSequence)
                .foregroundColor(.orange)
            Toggle(isOn: $oneLoop){
                Text("One Permutation of Word Set")
                    .foregroundColor(.orange)
                    .opacity(oneLoop ? 1 : 0.5)
            }
            VStack {
                Text("Strategy Settings")
                
                Toggle(isOn: $perfectMemory){
                    Text("Allow Bot to Remember Past Words")
                        .foregroundColor(.blue)
                }
                Toggle(isOn: $guessMethodFrequency){
                    Text("Use Guess Strategy Word Frequency")
                        .foregroundColor(.purple)
                }
                Toggle(isOn: $seekKnowledge){
                    Text("Use Guess Strategy Unplayed Letters")
                        .foregroundColor(.purple)
                }
                Stepper("Minimum Known Letters: \(limitCountIncludedLetters)", value: $limitCountIncludedLetters)
                    .foregroundColor(.purple)
                
            }
            VStack {
                Text("\"Cheating\" Settings")
                Toggle(isOn: $answersSortedByFrequency){
                    Text("Reorder Answers by Word Frequency")
                        .foregroundColor(.green)
                }
                Toggle(isOn: $totalCheater){
                    Text("Limit Dictionary to Answer Set")
                        .foregroundColor(.orange)
                }
                Toggle(isOn: $frequencyCheater){
                    Text("Limit Dictionary to Frequent Words")
                        .foregroundColor(.orange)
                }
            }
            
            VStack {
                Text("Special Game Settings")
                Toggle(isOn: $unluckiestBotInTheWorld){
                    Text("Unluckiest Bot In the World")
                        .foregroundColor(.red)
                }
                Toggle(isOn: $specialGame){
                    Text("Use 3 research-based seed-words")
                        .foregroundColor(.red)
                }
            }
            
        }
    }
    
    var initializeBot: some View {
        Button("Initialize Bot") {
            wordleBot.initializeBot(unluckiestBotInTheWorld: unluckiestBotInTheWorld, perfectMemory: perfectMemory, answersSortedByFrequency: answersSortedByFrequency, totalCheater: totalCheater, frequencyCheater: frequencyCheater, guessMethodFrequency: guessMethodFrequency, seekKnowledge: seekKnowledge, limitCountIncludedLetters: limitCountIncludedLetters, lengthOfSequence: lengthOfSequence, oneLoop: oneLoop, specialGame: specialGame)
        }
    }
    
    var autoGuess: some View {
        Button("auto guess") {
            wordleBot.autoguess()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordleBotView()
    }
}
