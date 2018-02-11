//
//  UIColor+Properties.swift
//  Color Picker
//
//  Created by Chris Gray on 1/19/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

extension UIColor {
    
//    convenience init(hexValue: String) {
//        var hex = hexValue
//        if hexValue.count == 7 {
//            hex = String(hexValue.suffix(6))
//        }
//
//        var red = 0
//        var green = 0
//        var blue = 0
//
//        //put this in a closure?
//        red += 16 * String(hex[0]!).getDecimalFromHexValue()!
//        red += String(hex[1]!).getDecimalFromHexValue()!
//        green += 16 * String(hex[2]!).getDecimalFromHexValue()!
//        green += String(hex[3]!).getDecimalFromHexValue()!
//        blue += 16 * String(hex[4]!).getDecimalFromHexValue()!
//        blue += String(hex[5]!).getDecimalFromHexValue()!
//
//        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
//    }
    
//    var isDark: Bool {
//        let redDarknessMultiplier: CGFloat = 0.299
//        let greenDarknessMultiplier: CGFloat = 0.587
//        let blueDarknessMultiplier: CGFloat = 0.114
//
//        let (red, green, blue, alpha) = self.rgbValues
//
//        let darkness = 1-((red*redDarknessMultiplier + green*greenDarknessMultiplier + blue*blueDarknessMultiplier)*alpha)
//        return darkness > 0.5 ? true : false
//    }
    
//    var hexValue: String {
//        get {
//            let (red, green, blue, alpha) = self.rgbValues
//            let rgbValues = [red, green, blue]
//            var hex = ""
//
//            for color in rgbValues {
//                if let intString = CGFloat(Int(color*alpha*255)/16).hexValue, let remainderString = (color*alpha*255).truncatingRemainder(dividingBy: 16).hexValue {
//                    hex += intString + remainderString
//                }
//            }
//            return hex
//        }
//    }
//
    var rgbValues: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
}


