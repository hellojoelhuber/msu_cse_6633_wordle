//
//  WordProfilerApp.swift
//  WordProfiler
//
//  Created by Joel Huber on 4/6/22.
//

import SwiftUI

@main
struct WordProfilerApp: App {
    var body: some Scene {
        WindowGroup {
            let profiler = WordProfilerViewModel()
            WordProfilerView(profiler: profiler)
        }
    }
}
