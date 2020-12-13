//
//  SettingMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxRelay

class SettingMainViewModel {
    
    private let db = Firestore.firestore()
    
    var myUID: String? {
        return Auth.auth().currentUser?.uid
    }
    var myEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    let mySettingProfile = BehaviorRelay<SettingUserInformation>(value: SettingUserInformation())
    
    var myNickname: String?
    var myDate: String?
    var myType: String?
    
    init() {
        self.userSetting()
    }
    
    func userSetting() {
        guard let userUID = self.myUID else {
            return
        }
        
        db.collection("users")
            .document("\(userUID)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    var settingProfile: SettingUserInformation = SettingUserInformation()
                    
                    if let nickname = data!["nickName"] as? String {
                        settingProfile.nickname = nickname
                    }
                    
                    if let type = data!["dpti"] as? String {
                        settingProfile.dpti = type
                    }
                    
                    if let createdAt = data!["created_at"] as? String {
                        settingProfile.registerDate = createdAt
                    }
                    
                    self?.mySettingProfile.accept(settingProfile)
                } else {
                    print("프로필에서 유저 데이터를 초기화하지 못했습니다.")
                }
                
                
            }
    }
    
    /*
     logout
     */
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // UserDefaults로 작동하는 것들이 있기 때문에 비워주고 로그아웃
            self.resetDefaults()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // UserDefaults 모두 비우기
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}
