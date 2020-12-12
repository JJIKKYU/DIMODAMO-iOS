//
//  EmptyCollectionCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/05.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

enum EmptyCellKinds {
    case artboard
    case dimoPeople
    case dpti
    case layer
    case blockUser
    case hotdimo
}

class EmptyCollectionCell: UICollectionViewCell {

    @IBOutlet weak var emptyIconImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyIconImageView: UIImageView!
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 16
            mainView.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
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
            self.emptyIconImageViewHeightConstraint.constant = 158
            self.emptyIconImageView.image = UIImage(named: "empty_icon_3")
            
            /*
             텍스트 세팅
             */
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo Bold", size: 17) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            textLabel.attributedText = attributedString
            
            break
            
        case .dimoPeople:
            self.emptyIconImageViewHeightConstraint.constant = 97
            self.emptyIconImageView.image = UIImage(named: "empty_icon_2")
            
            /*
             텍스트 세팅
             */
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo SemiBold", size: 13) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            textLabel.attributedText = attributedString
            break
            
        case .dpti:
            self.emptyIconImageViewHeightConstraint.constant = 97
            self.emptyIconImageView.image = UIImage(named: "empty_icon_3")
            
            /*
             텍스트 세팅
             */
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont(name: "Apple SD Gothic Neo SemiBold", size: 13) as Any,
                .foregroundColor : UIColor.appColor(.gray210),
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: titleAttributes)
            textLabel.attributedText = attributedString
            break
            
        // CollectionView로 이루어진 collecitonview는 없음
        default:
            break
        }
    }

}
