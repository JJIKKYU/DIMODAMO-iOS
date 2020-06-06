//
//  testViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/05/28.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var character: UIImageView!
    var bgCount : Int = 0
    let purpleDuration : Double = 2
    let orangeDuration : Double = 3
    
    // purple
    let imagesListArray : NSMutableArray = []
    // orange
    let imagesListArrayOrange : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        draw()
    }
    
    
    // Circle Drawing Function
    func draw() {
        // Purple
        for countValue in 0...59 {
            let image = UIImage(named: "BG_" + String(countValue))
            imagesListArray.add(image!)
        }
        
        // Orange
        for countValue in 0...89 {
            let image = UIImage(named: "orange_" + String(countValue))
            imagesListArrayOrange.add(image!)
        }
        
        
        bg.animationImages = imagesListArray as? [UIImage]
        bg.animationDuration = purpleDuration
        bg.startAnimating()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            bgCount += 1
            // purple
            if bgCount % 2 == 0 {
                character.image = UIImage(named: "Character_11")
                bg.animationImages = imagesListArray as? [UIImage]
                bg.animationDuration = purpleDuration
                bg.startAnimating()
                
            } else if bgCount % 2 == 1 { // orange
                character.image = UIImage(named: "Character_12")
                bg.animationImages = imagesListArrayOrange as? [UIImage]
                bg.animationDuration = orangeDuration
                bg.startAnimating()
            }
            
            
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    

}
