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
    
    init() {
        _ = APIService.fetchAllResultsRx()
            .map { data -> [[String : Any]] in
                struct Response : Decodable {
                    let results : [DptiResult]
                }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [[String : Any]]]
                let jsonResult = json!["Result"]!
                self.resultTypes = jsonResult
                
                return self.resultTypes
            }
        .map { resultArray -> DptiResult in
            var dptiResult : DptiResult = DptiResult()
            
            resultArray.forEach { (array: [String : Any]) in
                if array["type"] as! String == self.type {
                    dptiResult.type = array["type"] as! String
                    dptiResult.color = array["color"] as! String
                    dptiResult.colorHex = array["colorHex"] as! String
                    dptiResult.shape = array["shape"] as! String
                    dptiResult.desc = array["desc"] as! String
                    dptiResult.position = array["position"] as! String
                    dptiResult.design = array["design"] as! [String]
                    dptiResult.designDesc = array["designDesc"] as! [String]
                    dptiResult.toolImg = array["toolImg"] as! String
                    dptiResult.toolName = array["toolName"] as! String
                    dptiResult.todo = array["todo"] as! String
                    dptiResult.title = array["title"] as! String
                } else {
                    
                }
                
//                print(dptiResults)
            }
            return dptiResult
        }
        .take(1)
        .bind(to: resultObservable)
    }
}

