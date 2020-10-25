//
//  CommentCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet weak var commentNickname: UILabel!
    @IBOutlet weak var commentDescription: UITextView!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentHeart: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension CommentCell {
    func viewDesign() {
        commentDescription.textContainer.lineFragmentPadding = 0
        commentDescription.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        adjustUITextViewHeight(arg: commentDescription)
    }
    
    // 텍스트뷰 Height 딱 맞도록
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = false
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}
