//
//  EmptyCollectionCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/05.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class EmptyCollectionCell: UICollectionViewCell {

    @IBOutlet weak var emptyIconImageView: UIImageView!
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 16
            mainView.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 16
        layer.masksToBounds = false
        self.clipsToBounds = true
        self.appShadow(.s8)
        
        
    }

}
