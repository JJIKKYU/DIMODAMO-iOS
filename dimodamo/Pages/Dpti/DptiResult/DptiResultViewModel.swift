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

import FirebaseAuth
import FirebaseFirestore

class DptiResultViewModel {
    
    private let db = Firestore.firestore()
    
    var resultTypes : [[String : Any]] = []
    
    // Survey 이후 최종 User Type
    var type : String = "M_TI"
    
    var gender: String = ""
    
    lazy var genderObservable = BehaviorRelay(value: "M")
    
    lazy var resultObservable = BehaviorRelay<DptiResult>(value: DptiResult())

    lazy var typeDesc = resultObservable.map { $0.desc }
    
    lazy var designsDesc = resultObservable.map { $0.designDesc }
    
    lazy var toolDesc = resultObservable.map { $0.toolDesc }
    
    lazy var todoDesc = resultObservable.map { $0.todo }
    
    lazy var colorHex = resultObservable.map { UIColor(hexString: $0.colorHex) }
    
    
    init() {
        
        print("\(self.gender)를 정상적으로 받았습니다")
        print("Init : \(type)")
    }
    
    func setType(type: String) {
        self.type = type
        // 타입을 지정할 때, 저장도 함께 진행
        self.saveType()
       
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
                $0.type == self.getOnlyTypeWithoutGender(type: self.type)
            }
            print("$0.type = \(self.type)")
            return finalUserType[0]
        }
        .take(1)
        .bind(to: resultObservable)
    }
    
    // 검사 결과 유저 정보에 저장
    func saveType() {
        guard let userUID: String = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document("\(userUID)")
            .updateData(["dpti" : "\(self.type)"])
        
        print("유저의 dpti를 변경했습니다.")
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue("\(self.type)", forKey: "dpti")
        
        print("유저의 dpti, userDefaults도 변경했습니다.")
    }
    
    func getOnlyTypeWithoutGender(type: String) -> String {
        let startIdx = type.index(type.startIndex, offsetBy: 2)
        let endIdx = type.index(before: type.endIndex)
        let range = startIdx...endIdx
        
        return String(type[range])
    }
    
    func setGender(gender: String) {
        self.gender = gender
        self.genderObservable.accept(gender)
        print(self.genderObservable.value)
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
