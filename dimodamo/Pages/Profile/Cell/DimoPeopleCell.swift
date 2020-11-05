//
//  DimoPeopleCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class DimoPeopleCell: UICollectionViewCell {
    
    @IBOutlet weak var cellContentView: UIView! {
        didSet {
//            cellContentView.appShadow(.s20)
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
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var tpyeImage: UIImageView!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("OK")
        
        layer.cornerRadius = 24
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 16
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
