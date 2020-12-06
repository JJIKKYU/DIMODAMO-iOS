//
//  LoginViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/26.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase
import FirebaseAuth

class LoginViewModel {
    
    private let db = Firestore.firestore()
    
    var userEmailRelay = BehaviorRelay(value: "")
    var userPwRelay = BehaviorRelay(value: "")
    
    init() {
        
    }
    
    // 이메일 정규식
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.userEmailRelay.value)
    }
    
    // 패스워드
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,20}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: userPwRelay.value)
    }
    
    // 로컬 데이터 (UserDefaults)에 유저 데이터 저장
    // Splash 스크린에도 동일한 기능이 있으므로, 수정할 때 같이 수정
    func userDataSave() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document("\(userUID)").getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()
                
                guard let userNickname: String = data!["nickName"] as? String else {
                    return
                }
                
                guard let userDpti: String = data!["dpti"] as? String else {
                    return
                }
                
                guard let userInterest: [String] = data!["interest"] as? [String] else {
                    return
                }
                
                let userDefaults = UserDefaults.standard
                
                /*
                 유저 닉네임 설정
                 */
                var userDefaultsUserNickname = userDefaults.string(forKey: "nickname") ?? ""
                
                if userNickname != userDefaultsUserNickname {
                    userDefaults.setValue("\(userNickname)", forKey: "nickname")
                    userDefaultsUserNickname = userDefaults.string(forKey: "nickname") ?? ""
                }
                
                /*
                 유저 DPTI 설정
                 */
                var userDefaultsUserDpti = userDefaults.string(forKey: "dpti") ?? "DD"
                
                if userDpti != userDefaultsUserDpti {
                    userDefaults.setValue("\(userDpti)", forKey: "dpti")
                    userDefaultsUserDpti = userDefaults.string(forKey: "dpti") ?? "DD"
                }
                
                var userDefaultsUserInterest = userDefaults.array(forKey: "interest") ?? []
                
                // 개수가 안 맞다는 뜻은 아예 입력이 안되어 있다는 뜻이니까, 일단 이렇게 해서 작동 되도록
                if userInterest.count != userDefaultsUserInterest.count {
                    userDefaults.set(userInterest, forKey: "interest")
                    userDefaultsUserInterest = userDefaults.array(forKey: "interest") ?? []
                }
                
                print("유저의 닉네임은 \(userDefaultsUserNickname)이며, 유저의 타입은 \(userDefaultsUserDpti), 관심사는 \(userDefaultsUserInterest) 입니다.")
                
            } else {
                print("유저 데이터에 있는 타입과 닉네임이 유저디폴트로 입력되지 못했습니다.")
            }
        }
    }
}
