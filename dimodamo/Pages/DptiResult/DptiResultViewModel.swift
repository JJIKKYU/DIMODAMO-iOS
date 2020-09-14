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
    
    lazy var resultObservable = BehaviorRelay<DptiResult>(value: DptiResult(type: "", color: "", colorHex: "", shape: "", desc: "", position: "", design: [], designDesc: [], toolImg: "", toolName: "", toolDesc: "", todo: "", title: ""))
    
    lazy var typeTitle = resultObservable.map { $0.title }
    
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
            var dptiResults : DptiResult = DptiResult(type: "", color: "", colorHex: "", shape: "", desc: "", position: "", design: [], designDesc: [], toolImg: "", toolName: "", toolDesc: "", todo: "", title: "")
            
            resultArray.forEach { (array: [String : Any]) in
                dptiResults.type = array["type"] as! String
                dptiResults.color = array["color"] as! String
                dptiResults.colorHex = array["colorHex"] as! String
                dptiResults.shape = array["shape"] as! String
                dptiResults.desc = array["desc"] as! String
                dptiResults.position = array["position"] as! String
                dptiResults.design = array["design"] as! [String]
                dptiResults.designDesc = array["designDesc"] as! [String]
                dptiResults.toolImg = array["toolImg"] as! String
                dptiResults.toolName = array["toolName"] as! String
                dptiResults.todo = array["todo"] as! String
                dptiResults.title = array["title"] as! String
                
                print(dptiResults)
            }
            return dptiResults
        }
        .take(1)
        .bind(to: resultObservable)
    }
}

