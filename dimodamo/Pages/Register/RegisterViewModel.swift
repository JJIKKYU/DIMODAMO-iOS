//
//  RegisterViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/22.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class RegisterViewModel {
    
    // RegisterClause
    // 약관 동의
    var serviceBtnRelay = BehaviorRelay(value: false) // true일 경우 동의
    var serviceBtn2Relay = BehaviorRelay(value: false) // true일 경우 동의
    var markettingBtnRelay = BehaviorRelay(value: false) // true일 경우 동의
    
    // RegisterName
    // 이름 작성
    var userName: String = ""
    var nameRelay = BehaviorRelay(value: "")
    var isVailed: Bool { nameRelay.value.count >= 2 }
    
    init() {
        
    }
}
