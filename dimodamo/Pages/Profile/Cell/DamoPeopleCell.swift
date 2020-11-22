//
//  DamoPeopleCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DamoPeopleCell: UITableViewCell {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.cornerRadius = 16
            shadowView.appShadow(.s12)
        }
    }
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var backgroundPattern: UIImageView!
    @IBOutlet var tags: [UILabel]! {
        didSet {
            
            
            for tag in tags {
                tag.layer.cornerRadius = tag.frame.height / 2
                tag.layer.borderColor = UIColor.appColor(.system).cgColor
                tag.layer.borderWidth = 1.2
                tag.layer.masksToBounds = true
                
                tag.textAlignment = .center
                tag.attributedText = NSAttributedString.init(string: "안녕", attributes: [NSAttributedString.Key.baselineOffset : -1])
            
//                let labelWidthSize: CGFloat = tag.intrinsicContentSize.width + 32
//                tag.widthAnchor.constraint(equalToConstant: labelWidthSize).isActive = true
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
//            topContainer.roundCorners(corners: [.topLeft, .topRight], radius: 16)
            topContainer.layer.cornerRadius = 16
            topContainer.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var topContainerBottomView: UIView!
    
    @IBOutlet weak var profile: UIImageView!
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
