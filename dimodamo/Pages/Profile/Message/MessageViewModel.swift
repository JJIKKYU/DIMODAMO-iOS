//
//  File.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class MessageViewModel {
    // 이전 VC에서 Prepare로 미리 전달 받음
    let userUID = BehaviorRelay<String>(value: "")
    let userType = BehaviorRelay<String>(value: "")
    
    init() {
        
    }
}
