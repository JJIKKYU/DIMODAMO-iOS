//
//  LinkUploadCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class LinkUploadCell: UITableViewCell {

    var deleteCellDelegate: DeleteUploadCellDelegate?
    
    var tagIndex: Int?
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1.5
            containerView.layer.borderColor = UIColor.appColor(.white235).cgColor
            containerView.layer.cornerRadius = 8
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView! {
        didSet {
            thumbImageView.layer.cornerRadius = 4
            thumbImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func presssedDeleteBtn(_ sender: Any) {
        guard let tagIndex = tagIndex else {
            return
        }
        deleteCellDelegate?.deleteCell(tagIndex: tagIndex, Kinds: UploadCellKinds.link)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
