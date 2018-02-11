//
//  ImagePixelReader.swift
//  Color Picker
//
//  Created by Chris Gray on 1/31/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import Foundation
import UIKit

class ImagePixelReader
{
    var image: UIImage? {
        didSet {
            pixelData = getPixelData()
        }
    }
    
    private var pixelData: [UInt8]?
    
    //Credit for this method: https://stackoverflow.com/a/41640262/7993739
    func getPixelData() -> [UInt8]? {
        let size = image!.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        guard let cgImage = image!.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
    
    
    //every pixel is one point, can't have .5 pixels, so use Int
    //get area of prior pixels, multiply by 4 bytes per pixel
    
    func getColorFromPixel(_ pixel: CGPoint) -> UIColor? {
        let pixelByteLocation = ((Int(image!.size.width) * Int(pixel.y)) + Int(pixel.x)) * 4

        if let data = pixelData {
            let r = CGFloat(data[pixelByteLocation])/255
            let g = CGFloat(data[pixelByteLocation + 1])/255
            let b = CGFloat(data[pixelByteLocation + 2])/255
            let a = CGFloat(data[pixelByteLocation + 3])/255

            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        return nil
    }
}
