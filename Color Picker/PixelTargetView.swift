//
//  PixelTargetView.swift
//  Color Picker
//
//  Created by Chris Gray on 1/13/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

class PixelTargetView: UIView {
    
    private let centerRadius: CGFloat = 2
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func draw(_ rect: CGRect) {
        let centerPath = UIBezierPath(arcCenter: centerPoint, radius: centerRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: centerRadius*30, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        centerPath.fill()
        circlePath.stroke()
    }
}
