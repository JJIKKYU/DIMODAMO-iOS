//
//  SearchHistoryModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/01.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistoryModel: Object {
    @objc dynamic var isDeleted: Bool = false
    @objc dynamic var keyword: String = ""
    @objc dynamic var searchTime: Double = 0
}
