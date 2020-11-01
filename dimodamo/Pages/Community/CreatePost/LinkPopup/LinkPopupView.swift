//
//  LinkPopupView.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class LinkPopupView: UIView {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = UIColor.appColor(.white235).cgColor
            containerView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView! {
        didSet {
            thumbImageView.layer.cornerRadius = 4
            thumbImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var insertBtn: UIButton! {
        didSet {
            insertBtn.layer.cornerRadius = 12
            insertBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 4
            textField.layer.masksToBounds = true
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.appColor(.gray210).cgColor
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
//        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
//        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 307)
    }
    
    @IBAction func pressedCloseBtn(_ sender: Any) {
        self.isHidden = true
    }
    
}
