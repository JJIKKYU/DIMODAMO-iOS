//
//  ManitoChatViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class ManitoChatViewModel {
    
    /*
     상대방 유저 타입 -> 타입에 따라서 컬러 변경하기 위해서
     */
    let yourType = BehaviorRelay<String>(value: "")
    // 상대방 UID
    let yourUID = BehaviorRelay<String>(value: "")
    
    init() {
        
    }
}
