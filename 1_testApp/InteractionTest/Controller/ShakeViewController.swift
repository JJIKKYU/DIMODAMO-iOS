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
    var time : Int = 1
    var stopTimer : Bool = false
    var shakeCount : Int = 0
    var screen : ScreenSection = .beer
    var isMagicStart : Bool = false
    
    enum ScreenSection {
        case beer, magic
    }
    
    // particle Image Sequence
    let beerImagesListArray : NSMutableArray = []
    
    
    @IBOutlet weak var particle: UIImageView!
    @IBOutlet weak var shakeIcon: UIButton!
    @IBOutlet weak var shakeText: UILabel!
    @IBOutlet weak var shakeTextBox: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var message: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGyros()
        timerStart()
        ready()
        // br.transform.rotated(by: CGFloat(90/Double.pi))
        
        // Do any additional setup after loading the view.
        
        shakeIcon.imageView?.contentMode = .scaleAspectFit
        shakeIcon.contentVerticalAlignment = .center
        shakeIcon.contentHorizontalAlignment = .center
    }
    
    func ready() {
        switch screen {
        case .beer:
            startGyros()
            message.image = UIImage(named: "beer_message")
            shakeIcon.setImage(UIImage(named: "icon_beer"), for: .normal)
            shakeIcon.frame = CGRect(x: 155, y: 327, width: 105, height: 95)
            for countValue in 0...29 {
                let image = UIImage(named: "particle0_" + String(countValue))
                beerImagesListArray.add(image!)
            }
        
        case .magic:
            motionManager.stopDeviceMotionUpdates()
            message.image = UIImage(named: "magic_message")
            shakeIcon.setImage(UIImage(named: "magic_icon"), for: .normal)
            shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
            shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            shakeText.text = "공감하신다면 마법봉을 탭해주세요"
            shakeCount = 0
            shakeText.text = "매직쓰"
        }
        
        
        
        particle.animationImages = beerImagesListArray as? [UIImage]
        particle.animationDuration = 1
        particle.animationRepeatCount = 1
    }
    
    @IBAction func pressedShakeIcon(_ sender: UIButton) {
        switch screen {
        case .beer:
            break
        case .magic:
            if isMagicStart == false {
                UIView.animate(withDuration: 0.5) {
                    self.shakeText.alpha = 0
                    self.shakeTextBox.alpha = 0
                    self.message.alpha = 0
                    self.shakeIcon.frame = CGRect(x: 143, y: 291, width: 127, height: 182)
                    self.isMagicStart = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    if self.shakeCount % 2 == 0 {
                        self.shakeIcon.transform = CGAffineTransform(rotationAngle: (-45 * .pi) / 180.0)
                    } else if self.shakeCount % 2 == 1 {
                        self.shakeIcon.transform = CGAffineTransform(rotationAngle: (45 * .pi) / 180.0)
                    }
                    
                }
                self.shakeCount += 1
            }
            
            
        }
    }
    
    @IBAction func pressedNextButton(_ sender: Any) {
        switch screen {
              case .beer:
                screen = .magic
                ready()
              case .magic:
                screen = .beer
                ready()
                  break
              }
              
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
        particle.startAnimating()
        
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
