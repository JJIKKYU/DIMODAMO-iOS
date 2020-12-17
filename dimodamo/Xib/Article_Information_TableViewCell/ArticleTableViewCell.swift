//
//  ArticleTableViewCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    var topInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var rightInset: CGFloat = 0
    
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
        self.layoutIfNeeded()
        
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 24
        container.clipsToBounds = true
        container.appShadow(.s12)
        
        
        
        layer.cornerRadius = 24
        layer.masksToBounds = true
        
        articleCategory.articleCategoryDesign()
        setAspectImageHeight()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        titleImage?.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        titleImage.clipsToBounds = true
        titleImage.layer.cornerRadius = 24
        titleImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.layoutMargins = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    /*
     해상도에 맞추어 hieght 조절
     */
    func setAspectImageHeight() {
        let aspectHeight: CGFloat = (224 / 414) * UIScreen.main.bounds.width
        
        self.imageHeightConstraint.constant = aspectHeight
    }
    
}
