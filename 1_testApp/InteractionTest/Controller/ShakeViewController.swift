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
    var sojuTimer : Timer = Timer()
    var time : Int = 10
    var stopTimer : Bool = false
    var shakeCount : Int = 0
    var screen : ScreenSection = .beer
    var isMagicStart : Bool = false
    var isPaperStart : Bool = false
    var sojuCount : Int = 0
    var roll : CGFloat = CGFloat()
    
    enum ScreenSection {
        case beer, magic, cheer, paper, soju
    }
    
    // particle Image Sequence
    let beerImagesListArray : NSMutableArray = []
    let magicImagesListArray : NSMutableArray = []
    
    
    @IBOutlet weak var particle: UIImageView!
    @IBOutlet weak var shakeIcon: UIButton!
    @IBOutlet weak var cheerIcon: UIImageView!
    @IBOutlet weak var shakeText: UILabel!
    @IBOutlet weak var shakeTextBox: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var message: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            bg.image = UIImage(named: "beer_screen")
            cheerIcon.alpha = 0
            startGyros()
            message.image = UIImage(named: "beer_message")
            message.layer.frame = CGRect(x: 77, y: 244, width: 260, height: 66)
            shakeIcon.setImage(UIImage(named: "icon_beer"), for: .normal)
            shakeIcon.frame = CGRect(x: 155, y: 327, width: 105, height: 95)
            time = 10
            stopTimer = false
            timerStart()
            
            // particle 준비
            for countValue in 0...29 {
                let image = UIImage(named: "particle0_" + String(countValue))
                beerImagesListArray.add(image!)
            }
            
            particle.animationImages = beerImagesListArray as? [UIImage]
            particle.animationDuration = 1
            particle.animationRepeatCount = 1
        
        case .magic:
            bg.image = UIImage(named: "magic_screen")
            cheerIcon.alpha = 0
            motionManager.stopDeviceMotionUpdates()
            message.image = UIImage(named: "magic_message")
            message.layer.frame = CGRect(x: 77, y: 244, width: 260, height: 66)
            shakeIcon.setImage(UIImage(named: "magic_icon"), for: .normal)
            shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
            shakeText.text = "공감하신다면 마법봉을 탭해주세요"
            shakeCount = 0
            time = 10
            stopTimer = false
            
            // particle 준비
            for countValue in 0...29 {
                let image = UIImage(named: "particle_1_" + String(countValue))
                magicImagesListArray.add(image!)
            }
            
            particle.animationImages = magicImagesListArray as? [UIImage]
            particle.animationDuration = 0.5
            particle.animationRepeatCount = 1
            
        case .cheer:
            bg.image = UIImage(named: "cheer_screen")
            cheerIcon.alpha = 1
            shakeText.alpha = 1
            shakeTextBox.alpha = 1
            message.alpha = 1
            
            startGyros()
            message.image = UIImage(named: "cheer_message")
            message.layer.frame = CGRect(x: 96, y: 241, width: 223, height: 86)
            shakeIcon.frame = CGRect(x: 219, y: 382, width: 14, height: 91)
            shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            shakeIcon.setImage(UIImage(named: "cheer_icon"), for: .normal)
            shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
            shakeText.text = "응원하신다면 디바이스를 흔들어주세요"
            shakeCount = 0
            time = 10
            stopTimer = false
            timerStart()
            
            particle.animationImages = beerImagesListArray as? [UIImage]
            particle.animationDuration = 0.5
            particle.animationRepeatCount = 1
        case .paper:
            bg.image = UIImage(named: "paper_screen")
            cheerIcon.alpha = 0
            motionManager.stopDeviceMotionUpdates()
            
            shakeText.alpha = 1
            shakeTextBox.alpha = 1
            message.alpha = 1
            
            message.image = UIImage(named: "paper_message")
            message.layer.frame = CGRect(x: 82, y: 245, width: 255, height: 66)
            shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            shakeIcon.frame = CGRect(x: 165, y: 347, width: 83, height: 71)
            shakeIcon.setImage(UIImage(named: "paper_icon"), for: .normal)
            shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
            shakeText.text = "공감하신다면 종이비행기를 탭해주세요"
            shakeCount = 0
            time = 10
            stopTimer = false
            
            particle.animationImages = magicImagesListArray as? [UIImage]
            particle.animationDuration = 1
            particle.animationRepeatCount = 1
        case .soju:
            bg.image = UIImage(named: "soju_screen")
            cheerIcon.alpha = 0
            startGyros()
            
            shakeText.alpha = 1
            shakeTextBox.alpha = 1
            message.alpha = 1
            
            message.image = UIImage(named: "soju_message")
            message.layer.frame = CGRect(x: 82, y: 245, width: 255, height: 66)
            shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            shakeIcon.frame = CGRect(x: 195, y: 337, width: 25, height: 91)
            shakeIcon.setImage(UIImage(named: "soju_icon"), for: .normal)
            shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
            shakeText.text = "위로하신다면 디바이스를 기울여주세요"
            shakeCount = 0
            time = 10
            stopTimer = false
            timerStart()
            
            particle.animationImages = beerImagesListArray as? [UIImage]
            particle.animationDuration = 1
            particle.animationRepeatCount = 1
        }
        
        
        
        
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
                    self.shakeIcon.frame = CGRect(x: 143, y: 360, width: 127, height: 182)
                    self.shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                    self.isMagicStart = true
                    self.timerStart()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    if self.shakeCount % 2 == 0 {
                        self.shakeIcon.transform = CGAffineTransform(rotationAngle: (-45 * .pi) / 180.0)
                    } else if self.shakeCount % 2 == 1 {
                        self.shakeIcon.transform = CGAffineTransform(rotationAngle: (45 * .pi) / 180.0)
                    }
                    
                }
                self.shakeCount += 1
                self.particle.startAnimating()

            }
        case .cheer:
            break
        case .paper:
            
            
            if isPaperStart == false {
                timerStart()
                UIView.animate(withDuration: 0.5) {
                    self.shakeText.alpha = 0
                    self.shakeTextBox.alpha = 0
                    self.message.alpha = 0
                    self.shakeIcon.frame = CGRect(x: 123, y: 311, width: 166, height: 142)
                    self.shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    self.isPaperStart = true
                }
            } else {
                UIView.animate(withDuration: 1, animations: {
                    let move = CGAffineTransform(translationX: 100, y: -100)
                    self.shakeIcon.alpha = 0
                    
                    self.shakeIcon.transform = move
                    
                }) { (_) in
                    UIView.animate(withDuration: 0) {
                        self.shakeIcon.transform = CGAffineTransform.identity
                        self.shakeIcon.alpha = 1
                    }
                }
                self.shakeCount += 1
                self.particle.startAnimating()

            }
        case .soju:
            break
        }
    }
    
    @IBAction func pressedNextButton(_ sender: Any) {
        switch screen {
        case .beer:
            stopTimer = true
            timer.invalidate()
            screen = .magic
            ready()
        case .magic:
            stopTimer = true
            screen = .cheer
            timer.invalidate()
            ready()
        case .cheer:
            stopTimer = true
            screen = .paper
            timer.invalidate()
            ready()
            
        case .paper:
            stopTimer = true
            screen = .soju
            timer.invalidate()
            ready()
        case .soju:
            stopTimer = true
            screen = .beer
            timer.invalidate()
            ready()
        }
              
    }
    
    func startGyros() {
        
        
        
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data{
                // print(myData.attitude.pitch * 180 / Double.pi)
                
                self.roll = CGFloat(myData.attitude.roll * 180 / Double.pi)
                print(self.roll)
                // print(myData.attitude.yaw * 180 / Double.pi)
                //self.br.transform.rotated(by: CGFloat(myData.attitude.roll * 180 / Double.pi))
                if self.roll < 90.0 && self.roll > -90.0 {
                    self.shakeIcon.transform = CGAffineTransform(rotationAngle: (self.roll * .pi) / 180.0)
                }
                
                // soju 기울일 때
                if self.screen == .soju {
                    if self.roll > 70.0 || self.roll < -70.0 {
                        // self.sojuTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ShakeViewController.sojuTimeLimit), userInfo: nil, repeats: true)
                    }
                }
                
           }
       }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeCount += 1
            AudioServicesPlaySystemSound(1519)
            
            if screen == .cheer {
                self.particle.startAnimating()
            }
        }
    }

    func timerStart() {
        if screen == .soju {
            if stopTimer == false {
                sojuTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ShakeViewController.sojuTimeLimit), userInfo: nil, repeats: true)
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShakeViewController.timeLimit), userInfo: nil, repeats: true)
            }
        } else {
            if stopTimer == false {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShakeViewController.timeLimit), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func timerStop() {
        switch screen {
        case .beer:
            particle.startAnimating()
        case .magic:
            UIView.animate(withDuration: 0.5) {
                self.shakeText.alpha = 1
                self.shakeTextBox.alpha = 1
                self.message.alpha = 1
                self.shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
                self.shakeIcon.frame = CGRect(x: 155, y: 327, width: 105, height: 95)
                self.isMagicStart = false
            }
            
        case .cheer:
            particle.startAnimating()
        case .paper:
            UIView.animate(withDuration: 0.5) {
                self.shakeText.alpha = 1
                self.shakeTextBox.alpha = 1
                self.message.alpha = 1
                self.shakeIcon.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.shakeIcon.transform = CGAffineTransform(rotationAngle: 0)
                self.shakeIcon.frame = CGRect(x: 165, y: 347, width: 83, height: 71)
                self.isPaperStart = false
            }
        case .soju:
            particle.startAnimating()
        }
        
        
        stopTimer = true
        timer.invalidate()
    }
    
    @objc func sojuTimeLimit() {
        if time > 0 {
            if roll > 70.0 || roll < -70.0 {
                sojuCount += 1
                if sojuCount < 100 {
                    sojuCount += 1
                } else if sojuCount >= 100 {
                    sojuCount = 100
                }
                shakeText.text = "\(sojuCount)% 달성"
            }
            
            if sojuCount == 100 {
                time = 0
            }
        }
        
    }
    
    @objc func timeLimit() {
        if time > 0 {
            time -= 1
            if screen == .soju {
                return
            } else {
                shakeText.text = "00:0\(time) 초 남음"
            }
            
        } else {
            timerStop()
            if screen == .soju {
                return
            } else {
                shakeText.text = "+ \(shakeCount) 회"
            }
            
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
