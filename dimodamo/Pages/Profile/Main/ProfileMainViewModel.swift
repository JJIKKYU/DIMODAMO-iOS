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
    let userUID: String = Auth.auth().currentUser?.uid ?? ""
    
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
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "DD"
        profileSetting.accept(type)
    }
    
    func myDptiType() -> String {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "DD"
        return type
    }
    
    func myNickname() -> String {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "익명"
        return nickname
    }
    
    /*
     추천 디모인 로딩
     */
    func loadDimoPeople() {
        // 리로드 할 수도 있으니 비움
        self.dimoPeopleArr = []
        self.dimoPeopleArrIsLoading.accept(false)
        
        let userDefaults = UserDefaults.standard
        guard let userInterestArray: [String] = userDefaults.array(forKey: "interest") as? [String] else {
            return
        }
        let userInterest: String = userInterestArray[0]
        print("유저의 관심사는 \(userInterest) 입니다.")
        
        db.collection("users")
            .whereField("dpti", isNotEqualTo: "DD")
            .whereField("interest", arrayContains: "\(userInterest)")
            .limit(to: 4)
            .getDocuments{ [weak self] (querySnapshot, err) in
                if let err = err {
                    print("디모피플을 가져오는데 오류가 발생했습니다. \(err.localizedDescription)")
                } else {
                    
                    var newDimoPeopleArr: [DimoPeople] = []
                    
                    for (index, document) in querySnapshot!.documents.enumerated() {
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
            .order(by: "get_profile_score", descending: true)
//            .order(by: "dpti")
//            .whereField("dpti", isNotEqualTo: "DD")
            .limit(to: 4)
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
//                        print("newDimoPeopleArr = \(newHotDimoPeopleArr[0].nickname)")
                    }
                    
                    self?.hotDimoPeopleArr = newHotDimoPeopleArr
                    self?.hotDimoPeopleArrIsLoading.accept(true)
                }
            }
        
    }
    
    // DPTI를 진행했는지에 따라서 서비스 이용이 가능한지
    func interactionIsAbailable() -> Bool {
        let type = self.myDptiType()
        
        if type == "DD" {
            print("DPTI를 진행하지 않았으므로 이용이 제한됩니다.")
            return false
        } else {
            print("DPTI를 진행했으므로 서비스 이용이 가능합니다.")
            return true
        }
    }
}
