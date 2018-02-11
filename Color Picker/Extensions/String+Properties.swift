//
//  String+Properties.swift
//  Color Picker
//
//  Created by Chris Gray on 2/6/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import Foundation

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: Int) -> Character? {
        return self[self.index(self.startIndex, offsetBy: bounds)]
    }
    
    internal func getDecimalFromHexValue() -> Int? { //setting internal for project-specific extension
        let letters = ["A", "B", "C", "D", "E", "F"]
        if let intValue = Int(self) {
            return intValue
        } else {
            if let letterIndex = letters.index(of: self.uppercased()) {
                return 10 + letterIndex
            }
        }
        return nil
    }
}
