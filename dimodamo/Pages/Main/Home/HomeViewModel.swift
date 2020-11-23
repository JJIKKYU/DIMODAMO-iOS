//
//  HomeViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxRelay

class HomeViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let userUID: String = Auth.auth().currentUser?.uid ?? ""
    
    func myDptiType() -> String {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI"
        return type
    }
    
    func myNickname() -> String {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "익명"
        return nickname
    }
    
    init() {
        
    }
}
