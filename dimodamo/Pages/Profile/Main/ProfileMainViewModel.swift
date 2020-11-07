//
//  ProfileMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class ProfileMainViewModel {
    
    let profileSetting = BehaviorRelay<String>(value: "")
    
    init() {
        self.getUserType()
    }
    
    func getUserType() {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI"
        profileSetting.accept(type)
    }
}
