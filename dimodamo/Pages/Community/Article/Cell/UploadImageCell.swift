//
//  UploadImageCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/20.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class UploadImageCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewDesign()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}

// MARK: - Design

extension UploadImageCell {
    func viewDesign() {
        
        uploadImageView.layer.cornerRadius = 12
        uploadImageView.layer.masksToBounds = true
    }
}
