//
//  RecommendCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/30.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell {
    
    @IBOutlet weak var wordBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wordBtn.layer.cornerRadius = 18
        wordBtn.layer.borderWidth = 1.5
        wordBtn.layer.borderColor = UIColor.appColor(.system).cgColor
        wordBtn.layer.masksToBounds = true
    }
    
    @IBAction func pressedWordBtn(_ sender: Any) {
        print("추천 검색어")
    }
    
}
