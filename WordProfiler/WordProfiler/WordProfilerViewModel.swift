//
//  WordProfilerViewModel.swift
//  WordProfiler
//
//  Created by Joel Huber on 4/6/22.
//

import SwiftUI

class WordProfilerViewModel: ObservableObject {
    @Published var profiler: WordProfiler
    
    init() {
        profiler = WordProfiler.init()
    }
}

