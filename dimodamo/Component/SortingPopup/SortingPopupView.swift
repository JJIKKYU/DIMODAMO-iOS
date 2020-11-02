//
//  SortingPopupView.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/02.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

enum Sort: Int {
    case date = 0
    case scrap = 1
    case comment = 2
}

class SortingPopupView: UIView {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 14
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var sortingLabels: [UIView]!
    
    @IBOutlet var sortingCheckIcons: [UIImageView]! {
        didSet {
            if sortingCheckIcons.count < 3 {
                print("sortingCheckIcon이 3개 이하이므로 초기화에 실패했습니다.")
                return
            }
            
            sortingCheckIcons[Sort.scrap.rawValue].isHidden = true
            sortingCheckIcons[Sort.comment.rawValue].isHidden = true
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func pressedDateBtn(_ sender: Any) {
        sortingCheckIcons[Sort.date.rawValue].isHidden = false
        sortingCheckIcons[Sort.scrap.rawValue].isHidden = true
        sortingCheckIcons[Sort.comment.rawValue].isHidden = true
    }
    
    @IBAction func pressedScrapBtn(_ sender: Any) {
        sortingCheckIcons[Sort.date.rawValue].isHidden = true
        sortingCheckIcons[Sort.scrap.rawValue].isHidden = false
        sortingCheckIcons[Sort.comment.rawValue].isHidden = true
    }
    
    @IBAction func pressedCommentBtn(_ sender: Any) {
        sortingCheckIcons[Sort.date.rawValue].isHidden = true
        sortingCheckIcons[Sort.scrap.rawValue].isHidden = true
        sortingCheckIcons[Sort.comment.rawValue].isHidden = false
    }
}
