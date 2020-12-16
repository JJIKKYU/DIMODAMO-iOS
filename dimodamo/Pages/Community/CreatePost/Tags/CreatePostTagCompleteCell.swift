//
//  CreatePostTagCompleteCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

protocol TagDeleteBtn {
    func pressedDeleteBtn(index: Int)
}

class CreatePostTagCompleteCell: UICollectionViewCell {
    
    @IBOutlet weak var tagTextLabel: PaddingLabel! {
        didSet {
            tagTextLabel.layer.cornerRadius = (tagTextLabel.frame.height + 4 + 5)  / 2
            tagTextLabel.layer.masksToBounds = true
        }
    }
    var delegate: TagDeleteBtn? = nil
    var tagIndex: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    @IBAction func pressedTagDeleteBtn(_ sender: Any) {
        guard let index = self.tagIndex else {
            return
        }
        
        delegate?.pressedDeleteBtn(index: index)
    }
}
