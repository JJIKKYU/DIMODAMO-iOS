//
//  FirstIntroViewController.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

class FirstIntroViewController: UIViewController {

    @IBOutlet weak var animationContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieChar()
        // Do any additional setup after loading the view.
    }
    
    func lottieChar() {
        let animationView = Lottie.AnimationView.init(name: "splash_1_type")
//        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        
      
        
        
        animationContainerView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor).isActive = true

        
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
