//
//  ReportMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/08.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

class ReportMainViewModel {
    
    // 신고 가능한 항복
    let reportArr: [String] = [
        "부적절한 게시물",
        "부적절한 태그",
        "게시글 / 댓글 도배",
        "욕설",
        "특정 인물 비하 / 비방",
        "음란물",
        "불건전한 대화 / 만남 유도",
        "홍보성 컨텐츠",
        "상업적 광고 및 판매",
        "기타"
    ]
    
    // 현재 스크린에서 진행 중인 신고 타입
    var currentReportType: ReportType?
    
    // 신고하는 유저 UID
    var myUID: String {
        return Auth.auth().currentUser!.uid
    }
    
    // 신고할 콘텐츠 UID
    var contentUID: String?
    
    // 신고 당하는 유저
    var targetUserUID: String?
    
    init() {
        
    }
    
    
}
