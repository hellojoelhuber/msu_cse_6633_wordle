//
//  ContentView.swift
//  WordProfiler
//
//  Created by Joel Huber on 4/6/22.
//

import SwiftUI

struct WordProfilerView: View {
    @ObservedObject var profiler: WordProfilerViewModel
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Button("Tap me") {
                profiler.profiler.iterateAllWordSets()
//                profiler.profiler.iterateLesserWordSets()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let profiler = WordProfilerViewModel()
        WordProfilerView(profiler: profiler)
    }
}
