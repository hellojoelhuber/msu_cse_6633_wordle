//
//  ImageProcessor.swift
//  WordleParser
//
//  Created by Joel Huber on 3/18/22.
//

import Foundation
import SwiftImage

struct ImageProcessor {
    func printPuzzles() {
        var dictionaryTweets: [String:QuordleTweet] = [:]
//        var imageNames: [String] = []
//        for x in 1..<60 {
//            imageNames.append("wordle52_\(x)")
//        }
        let filename = "quordle57_tweets.json"
        if let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
//                print(data)
//                imageNames = parse(json: data)
                dictionaryTweets = parse(json: data)
            } catch {
                // Handle error here
            }
        }
//        imageNames = extractMediaNames(jsonTweets: dictionaryTweets)

        
        let start_time = DispatchTime.now()
        
        var arrayTweets: [QuordleTweet] = []
        var i = 0
        for entry in dictionaryTweets {
            let puzzleAnswer = explorePuzzle(imageName: String(entry.value.tweet_media_url.suffix(19)))
            arrayTweets.append(entry.value)
//            dictionaryTweets[entry.key]!.tweet_media_string = puzzleAnswer
            arrayTweets[i].tweet_media_string = puzzleAnswer
            i += 1
        }
        print(arrayTweets)
        
//        var grid = ""
//        for name in imageNames {
//            let puzzleAnswer = explorePuzzle(imageName: String(name.suffix(19)))
//            dictionaryTweets[name]!.tweet_media_string = puzzleAnswer
//            grid += puzzleAnswer
//            grid += "\n\n"
//        }
        let end_time = DispatchTime.now()
        let nanoTime = end_time.uptimeNanoseconds - start_time.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("example.json")

            try JSONEncoder().encode(arrayTweets)
                .write(to: fileURL)
        } catch {
            print(error)
        }

        print("Total elapsed time was : \(timeInterval).")
    }
    
    // This loops through 1 puzzle to get the layout of the data and returns it to the main loop
    // as a string to print as a single file.
    func explorePuzzle(imageName: String) -> String {
//        let imageName = "wordle52_11"
        let testImage = Image<RGBA<UInt8>>(named: imageName)!
        
        let squareWidth = findEdgeOfPuzzle(image: testImage) / 6
        
        var exploringPixel: RGBA<UInt8> = RGBA(0x000000FF)
        var grid = ""
        var x = 20
        var y = 20
//        grid = "\n\n\(imageName) \(testImage.width) x \(testImage.height)\n"
        while (y < testImage.height) {
            while (x < testImage.width) {
                exploringPixel = testImage[x, y]
                if exploringPixel == Pixel.black {
                    grid += "⬛️"
                } else if exploringPixel == Pixel.white {
                    grid += "⬜️"
                } else if exploringPixel == Pixel.green || exploringPixel == Pixel.greenJpg {
                    grid += "🟩"
                } else if exploringPixel == Pixel.yellow || exploringPixel == Pixel.yellowJpg {
                    grid += "🟨"
                } else {
                    grid += "🔷"
                }

                x += squareWidth
            }
            grid += "\n"
            x = 20
            y += squareWidth
        }
//        print(grid)
        return grid
    }
    
    // Returns the edge of the puzzle so that the puzzle has 6 squares.
    // This allows us to easily define the width of 1 square + padding.
    func findEdgeOfPuzzle(image: Image<RGBA<UInt8>>) -> Int {
        let centerOfImage = image.width / 2
        var movingPixel: RGBA<UInt8> = RGBA(0x000000FF)
        var x = centerOfImage
        
        for _ in centerOfImage..<image.width {
            movingPixel = image[x, 20]
            if (movingPixel == Pixel.yellow || movingPixel == Pixel.yellowJpg ||
                movingPixel == Pixel.green || movingPixel == Pixel.greenJpg ||
                movingPixel == Pixel.white) {
                break
            } else {
                x += 1
            }
        }
        
        return x
    }
    
    func parse(json: Data) -> [String:QuordleTweet] {
        let decoder = JSONDecoder()
        let jsonTweets = try? decoder.decode([String:QuordleTweet].self, from: json)
        return jsonTweets!
    }
    
}

struct QuordleTweet: Codable {
    var tweet_url: String
    var tweet_date: String
    var tweet_text: String
    var tweet_media_id: String
    var tweet_media_url: String
    var tweet_author_id: Int
    var tweet_query_string: String
    var tweet_media_string: String?
}


struct Pixel {
    static let black = RGBA(0x000000FF)
    static let yellow = RGBA(0xFFCC01FF)
    static let yellowJpg = RGBA(0xFFCC00FF)
    static let green = RGBA(0x00CC88FF)
    static let greenJpg = RGBA(0x01CB87FF)
    static let white = RGBA(0xE0E0E0FF)
}



