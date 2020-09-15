//
//  DptiResultViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DptiResultViewModel {
    var resultTypes : [[String : Any]] = []
    
    // Survey 이후 최종 User Type
    var type : String = "TI"
    
    lazy var resultObservable = BehaviorRelay<DptiResult>(value: DptiResult())
    
    lazy var typeTitle = resultObservable.map { $0.title }

    lazy var typeDesc = resultObservable.map { $0.desc }
    
    lazy var typeIcon = resultObservable.map { "BC_Type_\($0.shape)" }
    
    lazy var patternBG = resultObservable.map { "BC_BG_P_\($0.shape)"}
    
    lazy var positionIcon = resultObservable.map { "Icon_\($0.type)"}
    
    lazy var positonDesc = resultObservable.map { $0.position }
    
    lazy var designs = resultObservable.map { $0.design }
    
    lazy var designsDesc = resultObservable.map { $0.designDesc }
    
    lazy var toolImg = resultObservable.map { $0.toolImg }
    
    lazy var toolName = resultObservable.map { $0.toolName }
    
    lazy var toolDesc = resultObservable.map { $0.toolDesc }
    
    lazy var todoDesc = resultObservable.map { $0.todo }
    
    lazy var colorHex = resultObservable.map { UIColor(hexString: $0.colorHex) }
    
    init() {
        _ = APIService.fetchLocalJsonRx(fileName: "Results")
            .map { data -> [[String : Any]] in
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [[String : Any]]]
                let jsonResult = json!["Result"]!
                self.resultTypes = jsonResult
                
                return self.resultTypes
            }
        .map { resultArray -> [DptiResult] in
            var dptiResults : [DptiResult] = []
            
            resultArray.forEach { (array: [String : Any]) in
                let dptiResultObj = DptiResult.initVariables(item: array)
                dptiResults.append(dptiResultObj)
            }
            return dptiResults
        }
        .map { dptiResultsArray -> DptiResult in
            let finalUserType = dptiResultsArray.filter{
                $0.type == self.type
            }
            return finalUserType[0]
        }
        .take(1)
        .bind(to: resultObservable)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}