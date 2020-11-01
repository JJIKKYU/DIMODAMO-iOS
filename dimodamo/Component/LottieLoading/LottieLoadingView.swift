//
//  LottieLoadingView.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

class LottieLoadingView: UIView {

    let animationView = Lottie.AnimationView.init(name: "Loading2")
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        
        animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        animationView.loopMode = .loop
        animationView.play()
        
        print("ASDASDASDASD")
    }
    
    func playAnimation() {
        self.isHidden = false
        animationView.play()
    }
    
    func stopAnimation() {
        self.isHidden = true
        animationView.stop()
    }
    

}
