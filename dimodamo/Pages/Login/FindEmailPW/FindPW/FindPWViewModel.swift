//
//  FindPWViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/06.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import FirebaseAuth

class FindPWViewModel {
    
    var userSchoolIdRelay = BehaviorRelay(value: "")
    var userEmailRelay = BehaviorRelay(value: "")
    
    // 학번과 이메일을 정확하게 잘 입력할 경우 true, 아니면 fale
    var canSendEmail = BehaviorRelay<Bool>(value: false)
    var isValiedUserEmail = BehaviorRelay<MailCheck>(value: .none)
    
    init() {
        
    }
    
    func sendPasswordResetMail() {
        Auth.auth().sendPasswordReset(withEmail: "\(userEmailRelay.value)") { error in
            if error != nil {
                self.isValiedUserEmail.accept(.impossible)
            } else {
                print("이메일 전송")
                self.isValiedUserEmail.accept(.possible)
            }
        }
    }
    
    // 이메일 정규식
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.userEmailRelay.value)
    }
    
    // 학번과 이메일을 정확하게 잘 입력할 경우 true, 아니면 fale
    func checkCanSendEmail() {
        let isValiedSchoolId: Bool = userSchoolIdRelay.value.count >= 7
        let isValiedEmail: Bool = isValidEmail()
        
        if (isValiedSchoolId && isValiedEmail) == true {
            canSendEmail.accept(true)
        } else {
            canSendEmail.accept(false)
        }
        
        
    }
}
