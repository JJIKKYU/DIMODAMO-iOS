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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var scrapCnt: UILabel!
    @IBOutlet weak var commentCnt: UILabel!
    @IBOutlet weak var articleCategory: UILabel!
    
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
        
        
        articleCategory.articleCategoryDesign()
    }
}


extension UILabel {
    func articleCategoryDesign() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.appColor(.system).cgColor
        self.layer.frame = CGRect(x: 0, y: 0, width: 112, height: 28)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 112).isActive = true
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        self.layer.cornerRadius = 14
    }
}
