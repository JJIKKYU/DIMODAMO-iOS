//
//  ImageUploadCell.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit

protocol DeleteUploadImage {
    func deleteImage(tagIndex: Int)
}

class ImageUploadCell: UITableViewCell {

    var deleteUploadImageDelegate: DeleteUploadImage?
    // 업로드할 때 부여 (인덱스 역할)
    var tagIndex: Int?
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImageView: UIImageView! {
        didSet {
            uploadImageView.layer.cornerRadius = 12
            uploadImageView.layer.masksToBounds = true

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func pressedDeleteBtn(_ sender: Any) {
        print("사진을 삭제합니다")
        guard let tagIndex = tagIndex else {
            return
        }
        deleteUploadImageDelegate?.deleteImage(tagIndex: tagIndex)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
