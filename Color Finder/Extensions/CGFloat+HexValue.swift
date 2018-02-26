//
//  CGFloat+HexValue.swift
//  Color Picker
//
//  Created by Chris Gray on 1/19/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

extension CGFloat {
    var hexValue: String? {
        guard self < 16 && self >= 0 else {
            return nil
        }
        if self < 10 {
            return String(describing: Int(self))
        }
        else {
            let letters = ["A", "B", "C", "D", "E", "F"]
            return letters[Int(self)-10]
        }
    }
}
