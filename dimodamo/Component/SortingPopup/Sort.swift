//
//  Sort.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/04.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

enum Sort: Int {
    case date = 0
    case scrap = 1
    case comment = 2
    
    static func getTextLabel(sort: Sort) -> String {
        switch sort {
        case .comment:
            return "댓글순"
        case .date:
            return "최신순"
        case .scrap:
            return "스크랩순"
        }
    }
}
