//
//  ImageProcessor.swift
//  WordleParser
//
//  Created by Joel Huber on 3/18/22.
//

import Foundation
import SwiftImage

struct ImageProcessor {
//    static let image = Image<RGBA<UInt8>>(named: "quordle52-1")!
    static let blackPixel = RGBA(0x000000FF)
    static let yellowPixel = RGBA(0xFFCC01FF)
    static let greenPixel = RGBA(0x00CC88FF)
    static let whitePixel = RGBA(0xE0E0E0FF)

    let imageNames = ["quordle52-1","quordle52-2","quordle52-3","quordle52-4","quordle52-5"]
//    enum pixelColors {
//        case blackPixel = RGBA(0x000000FF)
//        case yellowPixel = RGBA(0xFFCC01FF)
//        case greenPixel = RGBA(0x00CC88FF)
//        case whitePixel = RGBA(0xE0E0E0FF)
//    }
    var pixel: RGBA<UInt8> = RGBA(0x000000FF)

    
    func printGrid() {
        var grid = ""
        
        var travelingPixel: RGBA<UInt8> = RGBA(0xE0E0E0FF)
        
        let start_time = DispatchTime.now()
        for _ in 0..<20 {
            for name in imageNames {
                let image = Image<RGBA<UInt8>>(named: name)!
                let imageHeight = image.height
                let imageWidth = image.width
                var y = 32
                var x = 32
                
                
                grid = "\n\n\(name) \(image.width) x \(image.height)\n"
                while (y < imageHeight) {
                    while (x < imageWidth) {
                        travelingPixel = image[x, y]
                        if travelingPixel == ImageProcessor.blackPixel {
                            grid += "⬛️"
                        } else if travelingPixel == ImageProcessor.whitePixel {
                            grid += "⬜️"
                        } else if travelingPixel == ImageProcessor.greenPixel {
                            grid += "🟩"
                        } else if travelingPixel == ImageProcessor.yellowPixel {
                            grid += "🟨"
                        } else {
                            grid += "🔷"
                        }
                        
        //                print(travelingPixel)
                        x += 68
                    }
                    grid += "\n"
                    x = 32
                    y += 68
                }
                print(grid)
            }
        }
        let end_time = DispatchTime.now()
        let nanoTime = end_time.uptimeNanoseconds - start_time.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Total elapsed time was : \(timeInterval).")
        
    }
    
//    mutating func printPixel() {
//        var x = 1
//        while (x < ImageProcessor.image.width) {
//            pixel = ImageProcessor.image[x, 32]
////            if (pixel == centerBlackPixel) {
//            if (pixel == RGBA(0x000000FF)) {
//                print("Found the black one")
//            } else if (pixel == ImageProcessor.yellowPixel) {
//                print("Found the yellow one")
//                break
//            }
//            print("Incrementing pixel, x = \(x)...")
//            x += 1
//        }
//        print(pixel)
//    }
}

