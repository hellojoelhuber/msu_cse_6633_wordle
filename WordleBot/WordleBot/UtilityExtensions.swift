//
//  UtilityExtensions.swift
//  WordleBot
//
//  Created by Joel Huber on 5/6/22.
//

import Foundation


// This extension allows us to refer to a specific character in a string by its position, as if it were an array of letters.
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

// This extension allows us to easily check if an array contains only True or only False.
extension Collection where Element == Bool {
    var allTrue: Bool { return allSatisfy{ $0 } }
    var allFalse: Bool { return allSatisfy{ !$0 } }
}
