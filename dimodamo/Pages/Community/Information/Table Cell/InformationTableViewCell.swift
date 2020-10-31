//
//  InformationTableViewCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/15.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet var tags: [UILabel]!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var scrapCnt: UILabel!
    @IBOutlet weak var commnetCnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension InformationTableViewCell {
    func viewDesign() {
//        tagDesign()
    }
    
    func tagDesign(){
        
        // 태그 내부 글자 수에 맞춰서 width, height 재설정
        for tag in tags {
            
            let textCount: Int = Int(tag.text!.count)
            
            let width: Int = (textCount * 10) + 20
            let height: Int = 20
            
            if tag.text?.count == 0 {
                
                tag.widthAnchor.constraint(equalToConstant: 0).isActive = true
                tag.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                break
            }
            
            tag.translatesAutoresizingMaskIntoConstraints = false
            tag.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
            tag.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            tag.layer.masksToBounds = true
            tag.layer.cornerRadius = 10
        }
    }
}
