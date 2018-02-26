//
//  HexColor.swift
//  Color Picker
//
//  Created by Chris Gray on 2/7/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import Foundation
import UIKit

struct HexColor
{
    //MARK: Inits
    
    init() {}
    init?(hex: String) {
        if !isValidHexValue(hex) {
            return nil
        } else {
            if hex.count == 7 {
                hexValue = String(hex.suffix(6))
            } else {
                hexValue = hex
            }
        }
    }
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        redValue = red; greenValue = green; blueValue = blue; alphaValue = alpha
    }
    init(color: UIColor) {
        color.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
    }
    
    //MARK: Private properties
    
    private let hexArray: [Character: Int] = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
                                      "8": 8, "9": 9, "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15]

    private(set) var hexValue: String? {
        get {
            var hex = ""
            for color in [redValue, greenValue, blueValue] {
                if let intString = CGFloat(Int(color*alphaValue*255)/16).hexValue, let remainderString = (color*alphaValue*255).truncatingRemainder(dividingBy: 16).hexValue {
                    hex += intString + remainderString
                }
            }
            return hex
        }
        set {
            //assuming valid hex value
            if let hex = newValue {
                if let red = convertHexToDecimal(firstValue: hex[0]!, secondValue: hex[1]!) {
                    if let green = convertHexToDecimal(firstValue: hex[2]!, secondValue: hex[3]!) {
                        if let blue = convertHexToDecimal(firstValue: hex[4]!, secondValue: hex[5]!) {
                            redValue = red
                            greenValue = green
                            blueValue = blue
                            alphaValue = 1.0
                        }
                    }
                }
            }
        }
    }
    
    private func isValidHexValue(_ hexValue: String) -> Bool {
        if hexValue.count < 6 || hexValue.count > 7 {
            return false
        }
        var hex = hexValue.uppercased()
        if hex.count == 7 {
            hex = String(hex.suffix(6))
        }
        for char in hex {
            if hexArray[char] == nil {
                return false
            }
        }
        return true
    }
    
    private func convertHexToDecimal(firstValue: Character, secondValue: Character) -> CGFloat? {
        if let firstDecimal = hexArray[firstValue], let secondDecimal = hexArray[secondValue] {
            return CGFloat(firstDecimal * 16 + secondDecimal)/255
        } else {
            return nil
        }
    }
    
    //MARK: Public properties
    
    //0-1 not 0-255
    var redValue: CGFloat = 0
    var greenValue: CGFloat = 0
    var blueValue: CGFloat = 0
    var alphaValue: CGFloat = 0
    
    var rgbValues: (CGFloat, CGFloat, CGFloat, CGFloat) {
        return (redValue, greenValue, blueValue, alphaValue)
    }
    
    var rgb255Values: (CGFloat, CGFloat, CGFloat, CGFloat) {
        let (intRed, intGreen, intBlue) = (Int(redValue*255), Int(greenValue*255), Int(blueValue*255))
        return (CGFloat(intRed), CGFloat(intGreen), CGFloat(intBlue), alphaValue)
    }
    
    var uiColor: UIColor {
        get {
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        }
        set {
            newValue.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
        }
    }
    
    var isDark: Bool {
        let redDarknessMultiplier: CGFloat = 0.299
        let greenDarknessMultiplier: CGFloat = 0.587
        let blueDarknessMultiplier: CGFloat = 0.114
        
        let darkness = 1-((redValue*redDarknessMultiplier + greenValue*greenDarknessMultiplier + blueValue*blueDarknessMultiplier)*alphaValue)
        return darkness > 0.5 ? true : false
    }
}
