//
//  MainManitoModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

class MainListManitoChat {
    var uid: String = ""
    var type: String = ""
    var nickname: String = ""
    var date: String = ""
    var lastChat: String = ""
    
    init(uid: String, type: String, nickname: String, date: String, lastChat: String) {
        self.uid = uid
        self.type = type
        self.nickname = nickname
        self.date = date
        self.lastChat = lastChat
    }
}
