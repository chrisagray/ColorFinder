//
//  ColorPickerViewController.swift
//  Color Picker
//
//  Created by Chris Gray on 1/8/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var hexValueButton: UIButton!
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
    
    private var redValue: CGFloat = 255
    private var greenValue: CGFloat = 255
    private var blueValue: CGFloat = 255
    private var alphaValue: CGFloat = 1.0
    
    private var backgroundColor = UIColor() {
        didSet {
            self.view.backgroundColor = backgroundColor
            textColor = backgroundColor.isDark ? .white : .black
            hexValueButton.setTitle("#\(backgroundColor.hexValue)", for: .normal)
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
            hexValueButton.setTitleColor(textColor, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(alphaSettingSwitched), name: NSNotification.Name("alphaSettingSwitched"), object: nil)
        backgroundColor = .white
    }
    
    @IBAction func copyColor(_ sender: UIButton) {
        UIPasteboard.general.string = sender.title(for: .normal)
    }
    
    @IBAction func changedColorValue(_ sender: Any) {
        var index: Int!
        var value: Float!
        if let slider = sender as? UISlider {
            index = sliders.index(of: slider)!
            value = slider.value
        } else if let stepper = sender as? UIStepper {
            index = steppers.index(of: stepper)!
            value = Float(stepper.value)
        }
        switch index {
        case 0:
            redValue = CGFloat(Int(value))
        case 1:
            greenValue = CGFloat(Int(value))
        case 2:
            blueValue = CGFloat(Int(value))
        case 3:
            alphaValue = CGFloat(value)
        default:
            break
        }
        syncSlidersAndSteppers()
        backgroundColor = UIColor(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: alphaValue)
    }
    
    private func syncSlidersAndSteppers() {
        //shouldn't move values if not needed
        
        redValueLabel.text! = "\(Int(redValue))"
        greenValueLabel.text! = "\(Int(greenValue))"
        blueValueLabel.text! = "\(Int(blueValue))"
        alphaValueLabel.text! = String(format:"%.2f", alphaValue)
        
        redSlider.value = Float(redValue)
        blueSlider.value = Float(blueValue)
        greenSlider.value = Float(greenValue)
        alphaSlider.value = Float(alphaValue)
        
        redStepper.value = Double(redValue)
        greenStepper.value = Double(greenValue)
        blueStepper.value = Double(blueValue)
        alphaStepper.value = Double(alphaValue)
    }
    
    
    @objc func alphaSettingSwitched() {
        showAlpha = !showAlpha
        
        if !showAlpha {
            redValue = redValue * alphaValue
            greenValue = greenValue * alphaValue
            blueValue = blueValue * alphaValue
            oldAlpha = alphaValue
            alphaValue = 1
        } else {
            alphaValue = oldAlpha
            if redValue/alphaValue > 255 || greenValue/alphaValue > 255 || blueValue/alphaValue > 255 {
                alphaValue = 1
            } else {
                redValue = redValue / alphaValue
                greenValue = greenValue / alphaValue
                blueValue = blueValue / alphaValue
            }
        }
        syncSlidersAndSteppers()
        backgroundColor = UIColor(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: alphaValue)
    }
}
