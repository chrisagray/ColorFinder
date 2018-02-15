//
//  HexColor.swift
//  Color Picker
//
//  Created by Chris Gray on 2/7/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import Foundation
import UIKit

//global?
private var hexadecimal: [Character: Int] = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
                                             "8": 8, "9": 9, "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15]

struct HexColor
{
    init() {}
    init(hex: String) {
        hexValue = hex
    }
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        redValue = red; greenValue = green; blueValue = blue; alphaValue = alpha
    }
    init(color: UIColor) {
        color.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
    }

    var hexValue: String {
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
            var hexValue = newValue.uppercased()
            if hexValue.count == 7 {
                hexValue = String(hexValue.suffix(6))
            }
            redValue = CGFloat(hexadecimal[hexValue[0]!]! * 16 + hexadecimal[hexValue[1]!]!)/255
            greenValue = CGFloat(hexadecimal[hexValue[2]!]! * 16 + hexadecimal[hexValue[3]!]!)/255
            blueValue = CGFloat(hexadecimal[hexValue[4]!]! * 16 + hexadecimal[hexValue[5]!]!)/255
            alphaValue = 1.0
        }
    }
    
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
