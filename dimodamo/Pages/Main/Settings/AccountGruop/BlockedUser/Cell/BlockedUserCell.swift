//
//  BlockedUserCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class BlockedUserCell: UITableViewCell {
    @IBOutlet weak var blockedUserProfileImageView: UIImageView!
    @IBOutlet weak var blockedUserNickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressedBlockCancelBtn(_ sender: Any) {
    }
}
