//
//  Article.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/18.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

struct Board {
    var boardId: String?
    var boardTitle: String?
    var bundleId: String?
    var category: Category?
    var commentCount: Int?
    var createdAt: String?
    var description: String?
    var images: [URL?]
    var links: [URL?]
    var nickname: String?
    var scrapCount: Int?
    var tags: [String?]
    var userDpti: String?
    var userId: String?
    var videos: [URL?]
    
    
    var dictionary: [String: Any] {
        return [
            "board_id" : boardId ?? "",
            "board_title": boardTitle ?? "",
            "bundle_id": bundleId ?? "",
            "category": category ?? .magazine,
            "comment_count": commentCount ?? 0,
            "created_at": createdAt ?? "",
            "description": description ?? "",
            "images": images,
            "links": links,
            "nickname": nickname ?? "",
            "scrap_count": scrapCount ?? 0,
            "tags": tags,
            "user_dpti": userDpti ?? "",
            "user_id": userId ?? "",
            "videos": videos,
            
        ]
    }
}

// 아티클에 필요한 모델
struct Article {
    var uid: String?
    var images: [URL?]
    var videos: [URL?]
    var category: Category?
    var title: String?
    var tags: [String]?
    var profile: URL?
    var nickname: String?
    var author: String?
    var scrapCnt: Int?
    var commentCnt: Int?
    
//    init() {
//        image = Data()
//        category = .magazine
//        title = "로딩중입니다"
//        tags = []
//        profile = Data()
//        nickname = "킹모다모"
//        author = ""
//        scrapCnt = 0
//        commentCnt = 0
//    }
}


// 아티클 카테고리
enum Category {
    case magazine
}
