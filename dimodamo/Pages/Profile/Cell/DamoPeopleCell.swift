//
//  DamoPeopleCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DamoPeopleCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.cornerRadius = 16
            shadowView.appShadow(.s12)
            
//            shadowView.layer.shadowColor = UIColor.black.cgColor
//            shadowView.layer.shadowOffset = CGSize(width: 0, height: -10)
//            shadowView.layer.shadowOpacity = 0.08
//            shadowView.layer.shadowRadius = 16
//            shadowView.layer.masksToBounds = false
//            shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        }
    }
    
    @IBOutlet weak var bottomContainer: UIView! {
        didSet {
            bottomContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
            bottomContainer.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 16
            containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var topContainer: UIView! {
        didSet {
            topContainer.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        }
    }
    
    @IBOutlet weak var profileBG: UIView! {
        didSet {
            profileBG.layer.cornerRadius = profileBG.frame.height / 2
            profileBG.layer.masksToBounds = true
            profileBG.backgroundColor = UIColor.appColor(.white255)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        // Configure the view for the selected state
    }

}
