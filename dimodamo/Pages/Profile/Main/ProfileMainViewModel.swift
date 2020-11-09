//
//  ProfileMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class ProfileMainViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let profileSetting = BehaviorRelay<String>(value: "")
    
    /*
     디모인
     */
    var dimoPeopleArr: [DimoPeople] = []
    let dimoPeopleArrIsLoading = BehaviorRelay<Bool>(value: false)
    
    /*
     핫한디모인
     */
    var hotDimoPeopleArr: [DimoPeople] = []
    let hotDimoPeopleArrIsLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        self.getUserType()
        self.loadDimoPeople()
        self.loadHotDimoPeople()
    }
    
    func getUserType() {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI"
        profileSetting.accept(type)
    }
    
    func loadDimoPeople() {
        // 리로드 할 수도 있으니 비움
        self.dimoPeopleArr = []
        self.dimoPeopleArrIsLoading.accept(false)
        
        db.collection("users")
            .whereField("school", isEqualTo: "홍익대학교")
            .limit(to: 4)
            .getDocuments{ [weak self] (querySnapshot, err) in
                if let err = err {
                    print("디모피플을 가져오는데 오류가 발생했습니다. \(err.localizedDescription)")
                } else {
                    
                    var newDimoPeopleArr: [DimoPeople] = []
                    
                    for (index, document) in querySnapshot!.documents.enumerated() {
                        let data = document.data()
                        let dimoPeopleData = DimoPeople()
                        
                        if let dptiType: String = data["dpti"] as? String {
                            dimoPeopleData.dpti = dptiType
                        }
                        
                        if let nickname: String = data["nickName"] as? String {
                            dimoPeopleData.nickname = nickname
                        }
                        
                        if let interests: [String] = data["interest"] as? [String] {
                            dimoPeopleData.interests = interests
                        }
                        
                        newDimoPeopleArr.append(dimoPeopleData)
                        print("newDimoPeopleArr = \(newDimoPeopleArr[index].nickname)")
                    }
                    
                    self?.dimoPeopleArr = newDimoPeopleArr
                    self?.dimoPeopleArrIsLoading.accept(true)
                }
            }
        
    }
    
    func loadHotDimoPeople() {
        // 리로드 할 수도 있으니 비움
        self.hotDimoPeopleArr = []
        self.hotDimoPeopleArrIsLoading.accept(false)
        
        db.collection("users")
            .whereField("school", isEqualTo: "홍익대학교")
            .order(by: "get_profile_score", descending: true)
            .limit(to: 4)
            .getDocuments{ [weak self] (querySnapshot, err) in
                if let err = err {
                    print("디모피플을 가져오는데 오류가 발생했습니다. \(err.localizedDescription)")
                } else {
                    
                    var newHotDimoPeopleArr: [DimoPeople] = []
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let dimoPeopleData = DimoPeople()
                        
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
//                        print("newDimoPeopleArr = \(newHotDimoPeopleArr[0].nickname)")
                    }
                    
                    self?.hotDimoPeopleArr = newHotDimoPeopleArr
                    self?.hotDimoPeopleArrIsLoading.accept(true)
                }
            }
        
    }
}
