//
//  DptiStartViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class DptiStartViewModel {
    
    let gender = BehaviorRelay<Gender>(value: .none)
    var isSelectedGender: Bool {
        if gender.value == .none {
            return false
        }
        return true
    }
    
    init() {
        
    }
}
