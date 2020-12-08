//
//  ReportCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectBtn() {
        if checkBtn.isSelected {
            self.checkBtn.isSelected = false
        } else {
            self.checkBtn.isSelected = true
        }
    }
    
    func unselectedBtn() {
        self.checkBtn.isSelected = false
    }

}
