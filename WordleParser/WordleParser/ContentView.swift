//
//  ContentView.swift
//  WordleParser
//
//  Created by Joel Huber on 3/18/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var processor: ImageProcessorViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
            Button("Tap me") {
//                processor.processor.printJson()

                processor.processor.printPuzzles()
            }
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let processor = ImageProcessorViewModel()
        ContentView(processor: processor)
    }
}
