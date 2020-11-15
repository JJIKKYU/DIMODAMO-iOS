//
//  ManitoApplyBtn.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ManitoApplyBtn: UIView {

    @IBOutlet weak var btnContainer: UIView! {
        didSet {
            btnContainer.backgroundColor = UIColor.white
            btnContainer.layer.cornerRadius = btnContainer.frame.height / 2
            btnContainer.layer.masksToBounds = true
            btnContainer.layer.borderWidth = 1.5
            btnContainer.layer.borderColor = UIColor.appColor(.system).cgColor
        }
    }
    @IBOutlet weak var manitoApplyBtn: UIButton!
    
    @IBOutlet weak var manitoApplyLabel: UILabel! {
        didSet {
            manitoApplyLabel.isHidden = true
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
