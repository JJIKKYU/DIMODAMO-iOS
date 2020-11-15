//
//  MyChatCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

protocol TableReloadProtocol {
    func tableReload()
}

class MyChatCell: UITableViewCell {
    
    var delegate: TableReloadProtocol?

    @IBOutlet weak var messageBox: PaddingLabel! {
        didSet {
            messageBox.layer.cornerRadius = 8
            messageBox.layer.masksToBounds = true
            messageBox.backgroundColor = UIColor.appColor(.white245)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSingleAndDoubleTapGesture()
    }

    @IBOutlet weak var goodIconImageView: UIImageView!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var goodContainer: UIView! {
        didSet {
            goodContainer.isHidden = true
        }
    }
    @IBOutlet weak var goodContainerHeightConstraint: NSLayoutConstraint! {
        didSet {
            goodContainerHeightConstraint.constant = 0
        }
    }
    @IBOutlet weak var goodContainerBottomConstraint: NSLayoutConstraint! {
        didSet {
            goodContainerBottomConstraint.constant = 0
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - 이미지 및 최고예요 컬러 변경
    func chagneColorGoodSign(yourType: String) {
        let color: UIColor = UIColor.dptiDarkColor(yourType)
        self.goodIconImageView.setImageColor(color: color)
        self.goodLabel.textColor = color
    }
    
    
    //MARK: - 최고예요
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        print("singleTap")
    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("doubleTap")
        self.goodContainer.isHidden = false
        self.goodContainerHeightConstraint.constant = 18
        self.goodContainerBottomConstraint.constant = 16
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.delegate?.tableReload()
        }
    }
}
