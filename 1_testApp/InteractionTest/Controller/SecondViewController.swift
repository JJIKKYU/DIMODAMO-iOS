//
//  SecondViewController.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/05/29.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var viewCon: UIView!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var LightButton: UIButton!
    @IBOutlet weak var lightText: UILabel!
    @IBOutlet weak var lockEmpty: UIImageView!
    @IBOutlet weak var lockPurple: UIImageView!
    @IBOutlet weak var lockText: UILabel!
    var isLongPressedLight : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        LightButton.addGestureRecognizer(longGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc func longTap(sender: UIGestureRecognizer) {
        print("Long tap")
        if sender.state == .ended {
            isLongPressedLight = false
            lightText.text = "조명을 가려주세요."
            lockText.text = "비밀메세지가 도착했어요!"
            
            UIView.animate(withDuration: 0.5) {
                self.viewCon.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.lockEmpty.alpha = 0
                self.lockPurple.alpha = 1.0
            }
        } else if sender.state == .began {
            isLongPressedLight = true
            lockText.text = "비밀메세지를 확인중입니다"
            UIView.animate(withDuration: 0.5) {
                self.viewCon.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.lockEmpty.alpha = 1.0
                self.lockPurple.alpha = 0
            }
        }
    }
    
    @objc func long() {
        print("long")
        viewCon.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
