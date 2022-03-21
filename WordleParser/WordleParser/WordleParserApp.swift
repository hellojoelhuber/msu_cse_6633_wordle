//
//  WordleParserApp.swift
//  WordleParser
//
//  Created by Joel Huber on 3/18/22.
//

import SwiftUI

@main
struct WordleParserApp: App {
    var body: some Scene {
        WindowGroup {
            let processor = ImageProcessorViewModel()
            ContentView(processor: processor)
        }
    }
}
