//
//  ProfileMainModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

class DimoPeople {
    var rank: Int = 0
    var dpti: String = ""
    var nickname: String = ""
    var interests: [String] = []
    
    func getProfileImage() -> UIImage {
        if dpti == "" {
            print("해당 유저는 DPTI 결과 값이 없습니다.")
        }
        return UIImage(named: "Profile_\(dpti)") ?? UIImage()
    }
    
    func getBackgroundColor() -> UIColor {
        if dpti == "" {
            print("해당 유저는 DPTI 결과 값이 없으므로 시스템 값을 리턴합니다.")
            return UIColor.appColor(.system)
        }
        let color = UIColor.dptiDarkColor("\(dpti)")
        return color
    }
    
    func getBackgroundPattern() -> UIImage {
        let image = UIImage.shapeBackgroundPattern(dpti)
        return image
    }
    
    func getTypeImage() -> UIImage {
        let typeImage = UIImage.dptiProfileTypeIcon(dpti, isFiiled: true)
        
        return typeImage
    }
}
