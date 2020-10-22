//
//  TextFieldRound.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class TextFieldRound: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.7
        self.layer.borderColor = UIColor.appColor(.gray210).cgColor
    }
    
}

class TextFieldContainerView: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.appShadow(.s20)
    }
}
