//
//  ImageColorChange.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/15.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
