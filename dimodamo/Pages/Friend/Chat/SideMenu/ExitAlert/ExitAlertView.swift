//
//  ExitAlertView.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ExitAlertView: UIView {

    @IBOutlet weak var bgSketchbookImage: UIImageView! {
        didSet {
            bgSketchbookImage.appShadow(.s8)
        }
    }
    @IBOutlet weak var goodCountContainer: UIView! {
        didSet {
            goodCountContainer.layer.cornerRadius = goodCountContainer.frame.height / 2
            goodCountContainer.layer.masksToBounds = true
            goodCountContainer.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var medalImage: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
