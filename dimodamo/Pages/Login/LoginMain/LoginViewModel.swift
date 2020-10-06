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

import FirebaseAuth

class LoginViewModel {
    
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
}
