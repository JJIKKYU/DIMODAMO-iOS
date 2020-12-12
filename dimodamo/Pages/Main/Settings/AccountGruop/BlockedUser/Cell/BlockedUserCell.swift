//
//  BlockedUserCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

protocol BlockCellPressedCancelBtnDelegate {
    func pressedCancleBtnInCell(index: Int, userUid: String)
}

class BlockedUserCell: UITableViewCell {
    
    var delegate: BlockCellPressedCancelBtnDelegate?
    
    var index: Int?
    var Uid: String?
    
    @IBOutlet weak var blockedUserProfileImageView: UIImageView!
    @IBOutlet weak var blockedUserNickname: UILabel!
    @IBOutlet weak var blockedCancleBtn: UIButton! {
        didSet {
            blockedCancleBtn.layer.cornerRadius = blockedCancleBtn.layer.frame.height / 2
            blockedCancleBtn.layer.borderWidth = 1
            blockedCancleBtn.layer.borderColor = UIColor.appColor(.gray170).cgColor
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

    @IBAction func pressedBlockCancelBtn(_ sender: Any) {
        if let index: Int = self.index,
           let Uid: String = self.Uid {
                delegate?.pressedCancleBtnInCell(index: index, userUid: Uid)
            }
        
        print("눌립니까")
    }
}
