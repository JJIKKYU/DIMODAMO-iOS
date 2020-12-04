//
//  CommentCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/21.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import SwipeCellKit

protocol CommentCellDelegate {
    func pressedCommentReply(type: String)
    func pressedHeartBtn(commentId: String, indexPathRow: Int)
}

class CommentCell: SwipeTableViewCell {
    
    // 유저가 DPTI를 진행했냐 안했냐에 따라서
    var isInteractionEnabledDPTI: Bool = false
    
    @IBOutlet weak var commentProfile: UIImageView!
    @IBOutlet weak var commentNickname: UILabel!
    @IBOutlet weak var commentDescription: UITextView!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentHeart: UILabel!
    @IBOutlet weak var commentHeartBtn: UIButton!
    @IBOutlet weak var commentAuthor: UIButton!
    
    @IBOutlet weak var commentProfileLeadingConstraint: NSLayoutConstraint!
    
    var indexpathRow: Int? = nil
    var userId: String? = nil
    var uid: String? = nil
    var dptiType: String?
    var viewModel: ArticleDetailViewModel?
    var commentDelegate: CommentCellDelegate?
    
    var selectedHeart: Bool = false
    
    
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
            commentDelegate?.pressedCommentReply(type: type)
        }
        
        
        let depth: Int = 1
        checkedViewModel.commentDepth = depth
        checkedViewModel.commentBundleId = selectedCommentBundleId!
    }
    
    @IBAction func pressedHeartBtn(_ sender: Any) {
        // DPTI를 진행하지 않았으면 바로 return
        if isUserInteractionEnabled == false { return }
        
        guard let checkedUid = uid else { return }
        guard let checkedIndexPathRow = indexpathRow else { return }
        
        commentDelegate?.pressedHeartBtn(commentId: checkedUid, indexPathRow: checkedIndexPathRow)
        guard let commentHeartText = commentHeart.text,
              let commentHeartInt = Int(commentHeartText) else {
            return
        }
        
        
        var finalCommentHeartCount: Int?
        
        if selectedHeart == false {
            commentHeartBtn.setImage(UIImage(named: "heartIconPressed"), for: .normal)
            finalCommentHeartCount = commentHeartInt + 1
            selectedHeart = true
        } else {
            commentHeartBtn.setImage(UIImage(named: "heartIcon"), for: .normal)
            finalCommentHeartCount = commentHeartInt - 1
            selectedHeart = false
        }
        
        if let finalCommentHeartCount = finalCommentHeartCount {
            commentHeart.text = "\(finalCommentHeartCount)"
        }
        
        
        
        
        //        checkedViewModel.pressedCommentHeart(uid: checkedUid)
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
