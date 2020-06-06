//
//  ViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/05/28.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet var swipe: UISwipeGestureRecognizer!
    @IBOutlet weak var character: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    
    var bgNumber : Int = 1
    var characterCount : Int = 0
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swipe의 default값이 .right이므로 .left로 변경
        swipe.direction = .left
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        
        
        if motionManager.isAccelerometerAvailable {
            
            var _ : CGFloat = character.frame.origin.y
            
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                
                // print(data!)
                // self.character.frame.origin.x += CGFloat(data!.acceleration.x)
                
                
                // self.character.frame.origin.y -= CGFloat(data!.acceleration.y)
            }
        }

    }
    
    @IBAction func swiping(_ sender: Any) {
        if swipe.direction == .left {
            if bgNumber < 4 {
                bgNumber += 1
            } else if bgNumber == 4 {
                bgNumber = 1
            }
            let bgName = "BG_0" + String(bgNumber)
            
            background.image = UIImage(named: bgName)!
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            characterCount += 1

            
            
            if characterCount % 2 == 0 {
                character.image = UIImage(named: "Character_10")
            } else if characterCount % 2 == 1 {
                character.image = UIImage(named: "Character_09")
            }
        }
    }
    

}

