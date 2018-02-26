//
//  UIImage+Orientation.swift
//  Color Picker
//
//  Created by Chris Gray on 1/18/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
