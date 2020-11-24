//
//  ProfileSearchViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/24.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//
import UIKit
import Foundation

import RxSwift
import RxRelay

import AlgoliaSearchClient

import SwiftyJSON

class ProfileSearchViewModel {
    
    let client = SearchClient(appID: "N13Z39TVCC", apiKey: "a61ca167a4f8cd2463ce8d0d886c2f65")
    lazy var index = client.index(withName: "hongik_users")
    
    var currentSearchText: String = ""
    let searchResultsRelay = BehaviorRelay<[Hit]>(value: [])

    
    init() {
        
    }
    
    func search() {
        var query = Query("\(currentSearchText)")
        query.attributesToRetrieve = ["nickName", "dpti", "interest"]
        query.hitsPerPage = 10
        index.search(query: query) { result in
            if case .success(let response) = result {
                
                let hits: [Hit]? = try? response.extractHits()
                
                guard let hitsResult: [Hit] = hits else {
                    return
                }
                
//                print("hitResult = \(hitsResult[0].nickName)")
                self.searchResultsRelay.accept(hitsResult)
                print("Response: \(hits)")
            }
        }
    }
}


struct Hit: Codable {
    let objectID: String
    let nickName: String?
    let interest: [String]?
    let dpti: String?
}
