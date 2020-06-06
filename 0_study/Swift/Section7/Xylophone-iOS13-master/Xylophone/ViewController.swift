//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation // Audio Visual Foundation



class ViewController: UIViewController {

    var player: AVAudioPlayer!
    
    var timer: Timer?
    var time: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func keyPressed(_ sender: UIButton)  {
        // playSound(senderTitle: sender.currentTitle)
        print("Click")
        
        if timer == nil {
            print("if")
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(activeTimer), userInfo: nil, repeats: true)
        }
       
        
        sender.alpha = 0.8
        
        if (time >= 2) {
            sender.alpha = 1
            timer?.invalidate()
        }
    }
    
    @objc func activeTimer() {
        time += 1
        
        if (time >= 2) {
            timer = nil
        }
        print(time)
    }
    
    func playSound(senderTitle : String?) {
        
        // let url = Bundle.main.url(forResource: senderTitle, withExtension: "wav")
        // player = try! AVAudioPlayer(contentsOf: url!)
        // player.play()
      //  print("play \(senderTitle)")
    }
}

