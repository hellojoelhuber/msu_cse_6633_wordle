//
//  ContentView.swift
//  WordleBot
//
//  Created by Joel Huber on 4/16/22.
//

import SwiftUI

struct WordleBotView: View {
    @ObservedObject var wordleBot: WordleBotViewController = WordleBotViewController()
    @State var guessMethodFrequency = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                Text("Won #\(wordleBot.getWins()) out of \(wordleBot.getTotalGames())")
            
                Spacer()
                
                autoGuess
                
                Spacer()
            }
            
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
