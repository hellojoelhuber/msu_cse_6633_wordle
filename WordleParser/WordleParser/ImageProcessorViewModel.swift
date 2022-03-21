//
//  ImageProcessorViewModel.swift
//  WordleParser
//
//  Created by Joel Huber on 3/18/22.
//

import Foundation

class ImageProcessorViewModel: ObservableObject {
    @Published var processor: ImageProcessor
    
    init() {
        processor = ImageProcessor.init()
    }
}
