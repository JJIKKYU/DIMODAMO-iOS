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
    
    init() {
        
    }
    
    func sendPasswordResetMail() {
        Auth.auth().sendPasswordReset(withEmail: "\(userEmailRelay.value)") { error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("이메일 전송")
            }
        }
    }
}
