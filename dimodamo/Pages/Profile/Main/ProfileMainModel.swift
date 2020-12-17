//
//  ProfileMainModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import UIKit

enum MedalKinds: Int {
    case comment = 0
    case scrap = 1
    case manito = 2
    
    static func getMedal(kind: MedalKinds, commentHeartCount: Int, manitoGoodCount:Int, documnetScrapCount: Int) -> UIImage {
        switch kind {
        case .comment:
            if commentHeartCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Big_Default_Heart") ?? UIImage()
            } else if commentHeartCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Big_Bronze_Heart") ?? UIImage()
            } else if commentHeartCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Silver_Heart") ?? UIImage()
            } else if commentHeartCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Gold_Heart") ?? UIImage()
            }
            
        case .manito:
            if manitoGoodCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Big_Default_Like") ?? UIImage()
            } else if manitoGoodCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Big_Bronze_Like") ?? UIImage()
            } else if manitoGoodCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Silver_Like") ?? UIImage()
            } else if manitoGoodCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Gold_Like") ?? UIImage()
            }
            
        case .scrap:
            if documnetScrapCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Big_Default_Scrap") ?? UIImage()
            } else if documnetScrapCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Big_Bronze_Scrap") ?? UIImage()
            } else if documnetScrapCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Silver_Scrap") ?? UIImage()
            } else if documnetScrapCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Big_Gold_Scrap") ?? UIImage()
            }
        }
        
        return UIImage()
    }
}

enum DimoKinds: Int {
    case dimo = 0
    case hotDimo = 1
    case myProfile = 2
}

class DimoPeople {
    var uid: String = ""
    var rank: Int = 0
    var dpti: String = ""
    var nickname: String = ""
    var interests: [String] = []
    
    /*
     핫한 디모인에서만 사용하는 변수
     */
    var commentHeartCount: Int = 0
    var documnetScrapCount: Int = 0
    var manitoGoodCount: Int = 0
    
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
    
    /*
     핫한 디모인에서 쓰이는 함수
     */
    
    func getMedal(kind: MedalKinds) -> UIImage {
        switch kind {
        case .comment:
            if commentHeartCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Small_Default_Heart") ?? UIImage()
            } else if commentHeartCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Small_Bronze_Heart") ?? UIImage()
            } else if commentHeartCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Silver_Heart") ?? UIImage()
            } else if commentHeartCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Gold_Heart") ?? UIImage()
            }
            
        case .manito:
            if manitoGoodCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Small_Default_Like") ?? UIImage()
            } else if manitoGoodCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Small_Bronze_Like") ?? UIImage()
            } else if manitoGoodCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Silver_Like") ?? UIImage()
            } else if manitoGoodCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Gold_Like") ?? UIImage()
            }
            
        case .scrap:
            if documnetScrapCount < 100 {
                return UIImage(named: "Profile_Medal_Icon_Small_Default_Scrap") ?? UIImage()
            } else if documnetScrapCount < 200 {
                return UIImage(named: "Profile_Medal_Icon_Small_Bronze_Scrap") ?? UIImage()
            } else if documnetScrapCount < 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Silver_Scrap") ?? UIImage()
            } else if documnetScrapCount >= 300 {
                return UIImage(named: "Profile_Medal_Icon_Small_Gold_Scrap") ?? UIImage()
            }
        }
        
        return UIImage()
    }
}
