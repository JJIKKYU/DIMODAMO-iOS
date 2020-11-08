//
//  AllDptiCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import Lottie

class AllDptiCell: UICollectionViewCell {
    
    @IBOutlet weak var bgPattern: UIImageView!
    @IBOutlet weak var resultCardView: UIView! {
        didSet {
            resultCardView.layer.cornerRadius = 24
            resultCardView.layer.masksToBounds = true
            resultCardView.backgroundColor = UIColor.dptiDarkColor("F_FN")
//            resultCardView.appShadow(.s12)
        }
    }
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var typeIcon: UIImageView! {
        didSet {
            typeIcon.appShadow(.s12)
        }
    }
    var isDrawLottieChar: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 24
        layer.masksToBounds = true
        self.appShadow(.s12)
    }
    
    func lottieChar(typeGender: String) {
        if isDrawLottieChar == true {
            return
        }
        let animationView = Lottie.AnimationView.init(name: "\(typeGender)")
//        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
//        resultCardView.translatesAutoresizingMaskIntoConstraints = false
        resultCardView.addSubview(animationView)
//        typeChar.rightAnchor.constraint(equalTo: resultCardView.rightAnchor, constant: 0).isActive = true
//        typeChar.bottomAnchor.constraint(equalTo: resultCardView.bottomAnchor, constant: 0).isActive = true
        
        

        animationView.layer.cornerRadius = 24
        animationView.play()
        animationView.loopMode = .loop
        isDrawLottieChar = true
    }
}
