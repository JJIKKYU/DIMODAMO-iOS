//
//  ArticleCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDesign()
    }
}


extension ArticleCell {
    func viewDesign() {
//        container.appShadow(.s12)
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 24
        layer.cornerRadius = 24
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 16
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    
    }
}
