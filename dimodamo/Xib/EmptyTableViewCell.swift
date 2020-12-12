//
//  EmptyTableViewCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewMainView: UIView! {
        didSet {
            tableViewMainView.layer.cornerRadius = 16
            tableViewMainView.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var tableViewEmptyLabel: UILabel!
    @IBOutlet weak var tableViewEmptyImageView: UIImageView!
    @IBOutlet weak var tableViewEmptyImageViewHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 16
        layer.masksToBounds = false
        self.clipsToBounds = true
        self.appShadow(.s8)
        
        
    }
    
    func settingImageSizeLabel(cellKinds: EmptyCellKinds, text: String) {
        
        switch cellKinds {
        case .artboard:
            
            tableViewEmptyImageViewHeightConstraint.constant = 158
            self.tableViewEmptyImageView.image = UIImage(named: "empty_icon_3")
            
            /*
             텍스트 세팅
             */
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo Bold", size: 17) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            tableViewEmptyLabel.attributedText = attributedString
            
            break
            
        case .layer:
            
            tableViewEmptyImageViewHeightConstraint.constant = 236
            self.tableViewEmptyImageView.image = UIImage(named: "empty_icon_4")
            
            /*
             텍스트 세팅
             */
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo Bold", size: 17) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            tableViewEmptyLabel.attributedText = attributedString
            
            break
            
        case .hotdimo:
            break
            
        default:
            break
        }
    }

}
