//
//  BreakViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class BreakViewController: UIViewController {

    var minutes = 30
    var seconds = 0
    var timer = Timer()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var breakLabel: UILabel!
    
    @IBAction func timeSliderAction(_ sender: UISlider) {
        minutes = Int(sender.value)
        
        if (minutes >= 60) {
            timeLabel.text = "\(String(minutes/60)) Hour(s), \(String(minutes % 60)) Minute(s)"

        } else {
            timeLabel.text = String(minutes) + " Minute(s)"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startAction(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        
        timeSlider.isHidden = true
        startButton.isHidden = true
        
        breakLabel.text = "You still have..."
    }
    
    @objc func counter() {

        if (minutes >= 60) {
            timeLabel.text = "\(String(minutes/60)) Hour(s), \(String(minutes % 60)) Minute(s)"

        } else {
            timeLabel.text = "\(String(minutes)) Minutes \(String(seconds)) Second(s)"
        }
        
        if (minutes == 0 && seconds == 0) {
            timer.invalidate()
            
            timeSlider.isHidden = false
            startButton.isHidden = false
            
            breakLabel.text = "You are breaking for..."
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if seconds == 0 {
            minutes -= 1
            seconds += 60
        }
        
        seconds -= 1
    }
    
    @IBAction func stopAction(_ sender: Any) {
        timer.invalidate()
        minutes = 30
        timeSlider.setValue(30, animated: true)
        timeLabel.text = "30 Minutes"
        
        timeSlider.isHidden = false
        startButton.isHidden = false
        
        breakLabel.text = "You are breaking for..."
    }
}
