//
//  SettingsTableViewController.swift
//  Color Picker
//
//  Created by Chris Gray on 1/9/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var sensitivitySlider: UISlider!
    
    private var sensitivity: Int {
        let subtractedSensitivity = Int(sensitivitySlider.maximumValue) - Int(round(sensitivitySlider.value))
        return subtractedSensitivity > 1 ? subtractedSensitivity : 1
    }
    
    private lazy var previousSensitivity = sensitivity
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if sensitivitySlider != nil {
            if sensitivity != previousSensitivity {
                previousSensitivity = sensitivity
                NotificationCenter.default.post(name: NSNotification.Name("changeSensitivity"), object: nil, userInfo: ["sensitivity": sensitivity])
            }
        }
    }
    
    @IBAction func alphaSettingChanged(_ sender: UISwitch) {
        NotificationCenter.default.post(name: NSNotification.Name("alphaSettingSwitched"), object: nil)
    }
}
