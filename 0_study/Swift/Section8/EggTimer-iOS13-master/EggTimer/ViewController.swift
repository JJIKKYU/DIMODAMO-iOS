//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var timers = Timer()
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    var totalTime = 0
    var secondsPassed = 0
    
    @IBAction func touchEgg(_ sender: UIButton) {

        timers.invalidate()
        let hardness = sender.currentTitle! // Soft, Medium, Hard
        
        
        
        totalTime = eggTimes[hardness]!
        
        
        timers = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            
            let percentageProgress = secondsPassed / totalTime
            progressBar.progress = Float(percentageProgress)
            secondsPassed += 1
        } else {
            titleLabel.text = "끝났습니다!"
        }
        
        
    }
   
    

}
