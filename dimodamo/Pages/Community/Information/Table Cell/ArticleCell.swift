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
    @IBOutlet weak var ArticleCategory: UILabel!
    
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
        
        
        articleCategoryDesign()
    }
    
    func articleCategoryDesign() {
        ArticleCategory.layer.borderWidth = 2
        ArticleCategory.layer.borderColor = UIColor.appColor(.system).cgColor
        ArticleCategory.layer.frame = CGRect(x: 0, y: 0, width: 112, height: 28)
        
        ArticleCategory.translatesAutoresizingMaskIntoConstraints = false
        ArticleCategory.widthAnchor.constraint(equalToConstant: 122).isActive = true
        ArticleCategory.heightAnchor.constraint(equalToConstant: 28).isActive = true
        ArticleCategory.layer.cornerRadius = 14
    }
}
