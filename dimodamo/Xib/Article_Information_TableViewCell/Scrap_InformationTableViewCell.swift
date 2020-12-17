//
//  InformationTableViewCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class Scrap_InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet var tags: [UILabel]! {
        didSet {
            for tag in tags {
                tag.layer.cornerRadius = tag.frame.height / 2
                tag.layer.masksToBounds = true
            }
        }
    }
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
