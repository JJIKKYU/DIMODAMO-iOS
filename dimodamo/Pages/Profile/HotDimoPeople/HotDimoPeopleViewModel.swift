//
//  HotDimoPeopleViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/11.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class HotDimoPeopleViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    /*
     핫한디모인
     */
    var hotDimoPeopleArr: [DimoPeople] = []
    let hotDimoPeopleArrIsLoading = BehaviorRelay<Bool>(value: false)
    
    var isTurnOnFilter: Bool = false
    
    init() {
        self.loadHotDimoPeople()
    }
    
    func loadDimoePeopleData() {
        let first = db.collection("users")
            .order(by: "get_profile_score", descending: true)
            .limit(to: 2)
        
        first.addSnapshotListener { [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            
            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty
                return
            }
            
            let next = self?.db.collection("users")
                .order(by: "get_profile_score", descending: true)
                .start(afterDocument: lastSnapshot)
        }
    }
    
    func loadHotDimoPeople() {
        // 리로드 할 수도 있으니 비움
        self.hotDimoPeopleArr = []
        self.hotDimoPeopleArrIsLoading.accept(false)
        
        db.collection("users")
            .order(by: "dpti")
            .whereField("dpti", isNotEqualTo: "DD")
            .order(by: "get_profile_score", descending: true)
            .getDocuments{ [weak self] (querySnapshot, err) in
                if let err = err {
                    print("디모피플을 가져오는데 오류가 발생했습니다. \(err.localizedDescription)")
                } else {
                    
                    var newHotDimoPeopleArr: [DimoPeople] = []
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let dimoPeopleData = DimoPeople()
                        
                        dimoPeopleData.uid = document.documentID
                        
                        if let dptiType: String = data["dpti"] as? String {
                            dimoPeopleData.dpti = dptiType
                        }
                        
                        if let nickname: String = data["nickName"] as? String {
                            dimoPeopleData.nickname = nickname
                        }
                        
                        if let interests: [String] = data["interest"] as? [String] {
                            dimoPeopleData.interests = interests
                        }
                        
                        if let commentHeartCount: Int = data["get_comment_heart_count"] as? Int {
                            dimoPeopleData.commentHeartCount = commentHeartCount
                        }
                        
                        if let manitoGoodCount: Int = data["get_manito_good_count"] as? Int {
                            dimoPeopleData.manitoGoodCount = manitoGoodCount
                        }
                    
                        if let scrapCount: Int = data["get_scrap_count"] as? Int {
                            dimoPeopleData.documnetScrapCount = scrapCount
                        }
                        
                        newHotDimoPeopleArr.append(dimoPeopleData)
                        print("newDimoPeopleArr = \(newHotDimoPeopleArr[0].nickname)")
                    }
                    
                    self?.hotDimoPeopleArr = newHotDimoPeopleArr
                    self?.hotDimoPeopleArrIsLoading.accept(true)
                }
            }
        
    }
}
