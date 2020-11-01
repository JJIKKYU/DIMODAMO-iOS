//
//  ImageUploadCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ImageUploadCell: UITableViewCell {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImageView: UIImageView! {
        didSet {
            uploadImageView.layer.cornerRadius = 12
            uploadImageView.layer.masksToBounds = true
            
            guard let image = uploadImageView.image else {
                return
            }
        
            let scaledHeight = ((UIScreen.main.bounds.width - 40) * image.size.height) / image.size.width
            heightConstraint.constant = scaledHeight
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
