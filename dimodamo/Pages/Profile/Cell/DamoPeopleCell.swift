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
    
    @IBOutlet var tags: [UILabel]! {
        didSet {
            for tag in tags {
                tag.layer.cornerRadius = tag.frame.height / 2
                tag.layer.borderColor = UIColor.appColor(.system).cgColor
                tag.layer.borderWidth = 1.2
                tag.layer.masksToBounds = true
                tag.widthAnchor.constraint(equalToConstant: 61).isActive = true
                tag.textAlignment = .center
                tag.attributedText = NSAttributedString.init(string: "안녕", attributes: [NSAttributedString.Key.baselineOffset : -1])
            }
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
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var commentHeartIcon: UIImageView!
    @IBOutlet weak var commentHeartCount: UILabel!
    
    @IBOutlet weak var scrapIcon: UIImageView!
    @IBOutlet weak var scrapCount: UILabel!
    
    @IBOutlet weak var manitoIcon: UIImageView!
    @IBOutlet weak var manitoCount: UILabel!
    
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
