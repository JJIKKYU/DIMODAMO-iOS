//
//  SecondIntroViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

class SecondIntroViewController: UIViewController {

    @IBOutlet weak var animationContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieChar()
        // Do any additional setup after loading the view.
    }
    
    func lottieChar() {
        let animationView = Lottie.AnimationView.init(name: "intro_2_room")
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore

        animationContainerView.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
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
