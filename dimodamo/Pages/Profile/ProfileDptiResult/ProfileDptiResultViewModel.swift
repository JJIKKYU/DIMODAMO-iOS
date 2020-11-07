//
//  ProfileDptiResultViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/07.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class ProfileDptiResultViewModel {
    
    var resultTypes : [[String : Any]] = []
    
    var type : String = "M_TI"
    var gender: String = "M"
    
    // 결과 모두를 가지고 있음
    lazy var resultObservable = BehaviorRelay<DptiResult>(value: DptiResult())
    
    lazy var typeDesc = resultObservable.map { $0.desc }
    
    lazy var designsDesc = resultObservable.map { $0.designDesc }
    
    lazy var toolDesc = resultObservable.map { $0.toolDesc }
    
    lazy var todoDesc = resultObservable.map { $0.todo }
    
    lazy var colorHex = resultObservable.map { UIColor(hexString: $0.colorHex) }
    
    init() {
        setTypeGender()
    }
    
    func setTypeGender() {
        
        let userDefaults = UserDefaults.standard
        let userDefaultsType = userDefaults.string(forKey: "dpti") ?? "M_TI"
        
        let onlyType: String = userDefaultsType.components(separatedBy: "_")[1]
        let onlyGender: String = userDefaultsType.components(separatedBy: "_")[0]
        
        self.type = onlyType
        self.gender = onlyGender
        
        print("type = \(self.type), gender = \(self.gender)")
       
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
            print("$0.type = \(self.type)")
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
