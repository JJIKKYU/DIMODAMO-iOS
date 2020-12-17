//
//  UserFCM.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RealmSwift

class UserFCM: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var fcm: String = ""
    
    convenience init(uid: String, fcm: String) {
        self.init()
        self.uid = uid
        self.fcm = fcm
    }
    
    // 기본키 설정
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    // 재정의하여 인덱스에 추가 속성을 설정
    override class func indexedProperties() -> [String] {
        return ["uid", "fcm"]
    }
}
