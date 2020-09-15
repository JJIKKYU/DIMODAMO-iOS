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
    var type : String = "JE"
    
    lazy var resultObservable = BehaviorRelay<DptiResult>(value: DptiResult())
    
    lazy var typeTitle = resultObservable.map { $0.title }

    lazy var typeDesc = resultObservable.map { $0.desc }
    
    lazy var positonDesc = resultObservable.map { $0.position }
    
    lazy var designs = resultObservable.map { $0.design }
    
    lazy var designsDesc = resultObservable.map { $0.designDesc }
    
    lazy var toolName = resultObservable.map { $0.toolName }
    
    lazy var toolDesc = resultObservable.map { $0.toolDesc }
    
    lazy var todoDesc = resultObservable.map { $0.todo }
    
    init() {
        _ = APIService.fetchAllResultsRx()
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
}

