//
//  MyProfileViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class MyProfileViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let profileSetting = BehaviorRelay<String>(value: "")
    let userProfileData = BehaviorRelay<UserProfileData>(value: UserProfileData())
    var userNickname: String = ""
    
    init() {
        self.getUserType()
        self.userSetting()
    }
    
    func getUserType() {
        
        guard let userNickname = UserDefaults.standard.string(forKey: "nickname"),
              let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI" else {
            return
        }
        
        self.userNickname = userNickname
        profileSetting.accept(type)
    }
    
    func userSetting() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users")
            .document("\(userUID)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let newUserProfile: UserProfileData = UserProfileData()
                    
                    if let nickname = data!["nickName"] as? String {
                        newUserProfile.nickname = nickname
                    }
                    
                    if let createdAt = data!["created_at"] as? String {
                        newUserProfile.createdAt = createdAt
                    }
                    
                    if let commentHeartCount = data!["get_comment_heart_count"] as? Int {
                        newUserProfile.commentHeartCount = commentHeartCount
                    }
                    
                    if let scrapCount = data!["get_scrap"] as? Int {
                        newUserProfile.scrapCount = scrapCount
                    }
                    
                    if let manitoGoodCount = data!["get_manito_good_count"] as? Int {
                        print("manitoGoodCount : \(manitoGoodCount)")
                        newUserProfile.manitoGoodCount = manitoGoodCount
                    }
                    
                    if let interests = data!["interest"] as? [String] {
                        print("interests : \(interests)")
                        newUserProfile.interests = interests
                    }
                    
                    self?.userProfileData.accept(newUserProfile)
                    print("userProfile = \(newUserProfile.commentHeartCount)")
                } else {
                    print("프로필에서 유저 데이터를 초기화하지 못했습니다.")
                }
                
                
            }
    }
}
