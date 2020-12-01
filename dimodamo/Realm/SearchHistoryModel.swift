//
//  SearchHistoryModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistory: Object {
    @objc dynamic var keyword = ""
    @objc dynamic var timestamp = 0
}
