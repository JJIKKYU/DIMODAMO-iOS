//
//  ShakeViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/05/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox

class ShakeViewController: UIViewController {
    
    let motionManager : CMMotionManager = CMMotionManager()
    var timer : Timer = Timer()
    var time : Int = 10
    var stopTimer : Bool = false
    var shakeCount : Int = 0
    
    
    @IBOutlet weak var shakeIcon: UIImageView!
    @IBOutlet weak var shakeText: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGyros()
        timerStart()
        // br.transform.rotated(by: CGFloat(90/Double.pi))
        
        // Do any additional setup after loading the view.
    }
    
    func startGyros() {
        
        var roll : CGFloat = CGFloat()
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data{
                // print(myData.attitude.pitch * 180 / Double.pi)
                print(myData.attitude.roll * 180 / Double.pi)
                roll = CGFloat(myData.attitude.roll * 180 / Double.pi)
                // print(myData.attitude.yaw * 180 / Double.pi)
                //self.br.transform.rotated(by: CGFloat(myData.attitude.roll * 180 / Double.pi))
                if (roll < 90.0 && roll > -90.0) {
                    self.shakeIcon.transform = CGAffineTransform(rotationAngle: (roll * .pi) / 180.0)
                }
           }
       }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeCount += 1
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    func timerStart() {
        if stopTimer == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShakeViewController.timeLimit), userInfo: nil, repeats: true)
        }
    }
    
    func timerStop() {
        stopTimer = true
        timer.invalidate()
    }
    
    @objc func timeLimit() {
        if time > 0 {
            time -= 1
            shakeText.text = "00:0\(time) 초 남음"
        } else {
            timerStop()
            shakeText.text = "+ \(shakeCount) 회"
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
