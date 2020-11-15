//
//  YoutChatCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

class YourChatCell: UITableViewCell{

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var messageBox: PaddingLabel! {
        didSet {
            messageBox.layer.cornerRadius = 8
            messageBox.layer.borderWidth = 1
            messageBox.layer.borderColor = UIColor.appColor(.pinkDark).cgColor
            messageBox.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSingleAndDoubleTapGesture()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

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
        print("YoutChatCell singleTap")
    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("YourChatCell doubleTap")
    }
}
