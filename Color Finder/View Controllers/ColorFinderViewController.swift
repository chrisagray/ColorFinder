//
//  ColorFinderViewController.swift
//  Color Picker
//
//  Created by Chris Gray on 1/8/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit
import BRYXBanner

func copyHexColorWithBanner(hex: String) {
    UIPasteboard.general.string = hex
    let banner = Banner(title: "Copied \(hex)", subtitle: nil, image: nil, backgroundColor: .white) {}
    
    banner.textColor = .black
    banner.minimumHeight = 64
    banner.show(duration: 0.5)
}

class ColorFinderViewController: UIViewController {
    
    @IBOutlet weak var hexValueButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    @IBOutlet weak var alphaValueLabel: UILabel!
    
    @IBOutlet weak var redStepper: UIStepper!
    @IBOutlet weak var greenStepper: UIStepper!
    @IBOutlet weak var blueStepper: UIStepper!
    @IBOutlet weak var alphaStepper: UIStepper!
    
    @IBOutlet var sliderValueLabels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var steppers: [UIStepper]!
    
    private var showAlpha = true {
        didSet {
            alphaSlider.isHidden = !showAlpha
            alphaValueLabel.isHidden = !showAlpha
            alphaStepper.isHidden = !showAlpha
        }
    }
    private var oldAlpha: CGFloat!
    
    private var backgroundColor = HexColor() {
        didSet {
            self.view.backgroundColor = backgroundColor.uiColor
            textColor = backgroundColor.isDark ? .white : .black
            hexValueButton.setTitle("#\(backgroundColor.hexValue!)", for: .normal)
            syncSlidersAndSteppers()
        }
    }
    
    private var textColor: UIColor? {
        didSet {
            sliderValueLabels.forEach { label in
                label.textColor = textColor
            }
            steppers.forEach { stepper in
                stepper.tintColor = textColor
            }
            buttons.forEach { button in
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(alphaSettingSwitched), name: NSNotification.Name("alphaSettingSwitched"), object: nil)
        backgroundColor.uiColor = .white
    }
    
    @IBAction func copyColor(_ sender: UIButton) {
        if let hexValue = hexValueButton.currentTitle {
            copyHexColorWithBanner(hex: hexValue)
        }
    }
    
    @IBAction func pasteColor(_ sender: UIButton) {
        if let copiedHexValue = UIPasteboard.general.string {
            if let newColor = HexColor(hex: copiedHexValue) {
                backgroundColor = newColor
            }
        }
    }
    
    @IBAction func changedColorValue(_ sender: Any) {
        var index: Int!
        var value: CGFloat!
        
        if let slider = sender as? UISlider {
            index = sliders.index(of: slider)!
            value = CGFloat(slider.value)
        } else if let stepper = sender as? UIStepper {
            index = steppers.index(of: stepper)!
            value = CGFloat(stepper.value)
        }
        
        let roundedValue = CGFloat(Int(value))
        
        switch index {
        case 0:
            backgroundColor.redValue = roundedValue/255
        case 1:
            backgroundColor.greenValue = roundedValue/255
        case 2:
            backgroundColor.blueValue = roundedValue/255
        case 3:
            backgroundColor.alphaValue = value
        default:
            break
        }
    }

    private func syncSlidersAndSteppers() {
        let (red, green, blue, alpha) = (backgroundColor.redValue*255, backgroundColor.greenValue*255, backgroundColor.blueValue*255, backgroundColor.alphaValue)

        redValueLabel.text! = "\(Int(red))"
        greenValueLabel.text! = "\(Int(green))"
        blueValueLabel.text! = "\(Int(blue))"
        alphaValueLabel.text! = String(format:"%.2f", alpha)

        redSlider.value = Float(red)
        blueSlider.value = Float(blue)
        greenSlider.value = Float(green)
        alphaSlider.value = Float(alpha)

        redStepper.value = Double(red)
        greenStepper.value = Double(green)
        blueStepper.value = Double(blue)
        alphaStepper.value = Double(alpha)
    }

    @objc func alphaSettingSwitched() {
        showAlpha = !showAlpha
        
        var (red, green, blue, alpha) = (backgroundColor.redValue*255, backgroundColor.greenValue*255, backgroundColor.blueValue*255, backgroundColor.alphaValue)
        
        if !showAlpha {
            red = red * alpha
            green = green * alpha
            blue = blue * alpha
            oldAlpha = alpha
            backgroundColor = HexColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        } else {
            var alpha = oldAlpha!
            if red/alpha > 255 || green/alpha > 255 || blue/alpha > 255 {
                alpha = 1
            } else {
                red /= alpha
                green /= alpha
                blue /= alpha
            }
            backgroundColor = HexColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        }
    }
}
