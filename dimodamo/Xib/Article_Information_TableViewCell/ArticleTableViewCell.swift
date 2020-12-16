//
//  ArticleTableViewCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var articleCategory: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 24
        layer.cornerRadius = 24
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 4)
//        layer.shadowOpacity = 0.12
//        layer.shadowRadius = 16
//        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        self.appShadow(.s12)
        articleCategory.articleCategoryDesign()
        setAspectImageHeight()
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     해상도에 맞추어 hieght 조절
     */
    func setAspectImageHeight() {
        let aspectHeight: CGFloat = (224 / 414) * UIScreen.main.bounds.width
        
        self.imageHeightConstraint.constant = aspectHeight
    }

}
