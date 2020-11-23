//
//  ServiceBannerCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ServiceBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 12
            imageView.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        self.appShadow(.s12)
    }
}
