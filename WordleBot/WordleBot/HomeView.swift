//
//  HomeView.swift
//  WordleBot
//
//  Created by Joel Huber on 4/25/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello, Wordle!\nWhat would you like to do today?")
            
            Spacer()
            
            HStack {
                Spacer()
                playWordle
                Spacer()
                playBot
                Spacer()
            }
            
            Spacer()
        }
    }
    
    var playWordle: some View {
        Button("Play Wordle") {
            print("play Wordle")
        }
    }
    
    var playBot: some View {
        Button("Play Bot") {
            print("play Wordle")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
