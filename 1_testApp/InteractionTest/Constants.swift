//
//  Constants.swift
//  week11_testApp
//
//  Created by JJIKKYU on 2020/06/09.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

struct Constants {
    static let appName = "⚡️FlashChat"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let cellIdentifier = "MessageCell"
    static let cellNibName = "MessageCell"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "message"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dataField = "date"
    }
    
}
