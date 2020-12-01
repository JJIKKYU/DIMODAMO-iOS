//
//  CommunitySearchViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RealmSwift

import RxSwift
import RxRelay

class CommunitySearchViewModel {
    
    var realm: Realm!
    
    let searchHistoryRelay = BehaviorRelay<[SearchHistoryModel]>(value: [])
    
    init() {
        realm = try! Realm()
        self.readHistory()
    }
    
    func createHistroy(searchText: String) {
        let searchHistory = SearchHistoryModel()
        
        let unixTimestamp = NSDate().timeIntervalSince1970
        
        searchHistory.keyword = "\(searchText)"
        searchHistory.searchTime = unixTimestamp
        
        try! realm.write {
            realm.add(searchHistory)
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func readHistory() {
        let historyList = realm.objects(SearchHistoryModel.self).filter("isDeleted == false")
        let resultArray = NSArray(array: Array(historyList)) as! [SearchHistoryModel]
        self.searchHistoryRelay.accept(resultArray)
        
        print(searchHistoryRelay.value)
    }
    
    func allDeleteHistry() {
        try! realm.write {
            realm.delete(realm.objects(SearchHistoryModel.self))
        }
        
        self.searchHistoryRelay.accept([])
    }
}
