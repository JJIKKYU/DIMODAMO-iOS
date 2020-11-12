//
//  YoutChatCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class YoutChatCell: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var messageBox: PaddingLabel! {
        didSet {
            messageBox.layer.cornerRadius = 8
            messageBox.layer.borderWidth = 1
            messageBox.layer.borderColor = UIColor.appColor(.pinkDark).cgColor
            messageBox.layer.masksToBounds = true
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
