//
//  Block_Realm.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RealmSwift

class BlockUser: Object {
    @objc dynamic var block_user_uid: String = ""
    @objc dynamic var timestamp: Double = 0.0
    
    override static func primaryKey() -> String? {
       return "block_user_uid"
     }
}
