//
//  MyChatCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class MyChatCell: UITableViewCell {

    @IBOutlet weak var messageBox: PaddingLabel! {
        didSet {
            messageBox.layer.cornerRadius = 8
            messageBox.layer.masksToBounds = true
            messageBox.backgroundColor = UIColor.appColor(.white245)
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
