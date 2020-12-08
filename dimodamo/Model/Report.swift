//
//  Report.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/03.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

class Report {
    var reportId: String = "" // 신고 Doc의 UID
    var targetType: Int = ReportType.post.rawValue // post = 0, comment = 1, user = 2
    var targetId: String = "" // 신고한 게시글 및 댓글의 UID
    var targetUserId: String = "" // 신고 당한 사람
    var userId: String = "" // 신고한 사람
    var reportKind: String = "" // 신고 종류
    var reportDesc: String = "" // 신고 내용
    var timestamp: Double = 0.0
    
    var dictionary: [String: Any] {
        return [
            "report_id": reportId,
            "target_type" : targetType,
            "target_id": targetId,
            "target_user_id": targetUserId,
            "user_id": userId,
            "report_kind": reportKind,
            "report_desc": reportDesc,
            "timestamp": timestamp
        ]
    }
}

// 게시글인지 코멘트인지 선택
enum ReportType: Int {
    case post = 0
    case comment = 1
    case user = 2
}

// 아티클인지 인포메이션 게시판인지 선택
enum TargetBoard: Int {
    case article = 0
    case information = 1
}

// 게시글 신고 종류
enum ReportKinds: Int {
    case improper = 0 // 부적절한 게시물
    case porno = 1  // 음란물
    case blame = 2 // 욕설 및 비하
    case fishing = 3 // 낙시 및 도배
}
