//
//  AllDptiViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class AllDptiViewModel {
    
    let resultObservable = BehaviorRelay<[DptiResult]>(value: [])
    
    var typeFArr: [DptiResult] = []
    var typeTArr: [DptiResult] = []
    var typePArr: [DptiResult] = []
    var typeJArr: [DptiResult] = []
    
    init() {
        self.setTypeGender()
    }
    
    func setTypeGender() {
        _ = APIService.fetchLocalJsonRx(fileName: "Results")
            .map { data -> [[String : Any]] in
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [[String : Any]]]
                let jsonResult = json!["Result"]!
                
                return jsonResult
            }
        .map { resultArray -> [DptiResult] in
            var dptiResults : [DptiResult] = []
            
            resultArray.forEach { (array: [String : Any]) in
                let dptiResultObj = DptiResult.initVariables(item: array)
                dptiResults.append(dptiResultObj)
            }
            
            self.settingTypeResults(results: dptiResults)
            return dptiResults
        }
        .take(1)
        .bind(to: resultObservable)
    }
    
    func settingTypeResults(results: [DptiResult]) {
        var typeFArr: [DptiResult] = []
        var typeTArr: [DptiResult] = []
        var typePArr: [DptiResult] = []
        var typeJArr: [DptiResult] = []
        
        for result in results {
            let typeCharacter = result.type[result.type.index(result.type.startIndex, offsetBy: 0)]
            if typeCharacter == "F" {
                typeFArr.append(result)
            } else if typeCharacter == "T" {
                typeTArr.append(result)
            } else if typeCharacter == "P" {
                typePArr.append(result)
            } else if typeCharacter == "J" {
                typeJArr.append(result)
            }
        }
        
        self.typeFArr = typeFArr
        self.typeTArr = typeTArr
        self.typePArr = typePArr
        self.typeJArr = typeJArr
    }
}
