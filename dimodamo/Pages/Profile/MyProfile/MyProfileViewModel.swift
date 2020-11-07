//
//  MyProfileViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class MyProfileViewModel {
    
    let profileSetting = BehaviorRelay<String>(value: "")
    
    init() {
        self.getUserType()
    }
    
    func getUserType() {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI"
        profileSetting.accept(type)
    }
}
