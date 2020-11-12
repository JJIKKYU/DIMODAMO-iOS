//
//  MainChatCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class MainChatCell: UITableViewCell {

    @IBOutlet weak var chatProfile: UIImageView!
    @IBOutlet weak var chatNickname: UILabel!
    @IBOutlet weak var chatDescription: UILabel!
    @IBOutlet weak var chatDate: UILabel!
    @IBOutlet weak var chatRemainCount: PaddingLabel! {
        didSet {
            chatRemainCount.layer.cornerRadius = chatRemainCount.frame.height / 2
            chatRemainCount.layer.masksToBounds = true
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
