//
//  TagCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
