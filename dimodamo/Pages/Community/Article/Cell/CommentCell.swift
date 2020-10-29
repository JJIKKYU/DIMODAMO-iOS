//
//  CommentCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

protocol CommentCellDelegate {
    func PressedCommentReply(type: String)
}

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet weak var commentNickname: UILabel!
    @IBOutlet weak var commentDescription: UITextView!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentHeart: UILabel!
    @IBOutlet weak var commentAuthor: UIButton!
    
    @IBOutlet weak var commentProfileLeadingConstraint: NSLayoutConstraint!
    
    var indexpathRow: Int? = nil
    var uid: String? = nil
    var dptiType: String?
    var viewModel: ArticleDetailViewModel?
    var delegate: CommentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pressedReplyBtn(_ sender: Any) {
        guard let checkedViewModel = viewModel else { return }
        guard let index = indexpathRow else { return }
        let selectedCommentBundleId = checkedViewModel.commentsRelay.value[index].bundleId
        
        if let type = self.dptiType {
            delegate?.PressedCommentReply(type: type)
        }
        
        
        let depth: Int = 1
        checkedViewModel.commentDepth = depth
        checkedViewModel.commentBundleId = selectedCommentBundleId!
    }
    
    @IBAction func pressedHeartBtn(_ sender: Any) {
        guard let checkedViewModel = viewModel else { return }
        guard let checkedUid = uid else { return }
        checkedViewModel.pressedCommentHeart(uid: checkedUid)
    }
}


extension CommentCell {
    func viewDesign() {
        commentDescription.textContainer.lineFragmentPadding = 0
        commentDescription.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        adjustUITextViewHeight(arg: commentDescription)
        commentAuthor.isHidden = true
    }
    
    // 텍스트뷰 Height 딱 맞도록
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = false
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}
