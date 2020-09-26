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
    var userEmail: String = ""
    var userEmailRelay = BehaviorRelay(value: "")
    var isVailed: Bool { userEmailRelay.value.count >= 2 } // 이메일 정규식 확인
    
    // RegisterBirth
    // 생년월일
    var birth = BehaviorRelay(value: "")
    var month = BehaviorRelay(value: "")
    var day = BehaviorRelay(value: "")
    lazy var birthMonthDay: String = "\(birth.value)_\(month.value)_\(day.value)"
    
    // RegisterGender
    // 성별
    var gender: Gender? = nil
    
    // RegisterInterest
    // 관심사
    var interestList: BehaviorRelay<[Interest]> = BehaviorRelay(value: [])

    // RegisterNickname
    // 닉네임 입력
    var nickName: String = ""
    var nickNameRelay = BehaviorRelay(value: "")
    var isVailedNickName: Bool { nickNameRelay.value.count >= 4 && nickNameRelay.value.count <= 8 }
    
    
    init() {
        
    }
    
    func isValiedBirth() -> Bool {
        var birthValied: Bool = false
        if birth.value.count >= 4 && Int(birth.value)! < 2020 {
            birthValied = true
        } else { birthValied = false }
        
        var monthValied: Bool = false
        if month.value.count >= 2 && Int(month.value)! <= 12 {
            monthValied = true
        } else { monthValied = false }
        
        var dayValied: Bool = false
        if month.value.count >= 2 && Int(day.value)! <= 31 {
            dayValied = true
        } else { dayValied = false }
        
        if birthValied && monthValied && dayValied {
            return true
        } else { return false }
    }
}
