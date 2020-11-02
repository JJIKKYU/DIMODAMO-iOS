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
    var bundleId: Double?
    var category: String?
    var commentCount: Int?
    var createdAt: String?
    var description: String?
    var images: [String]?
    var links: [String]?
    var nickname: String?
    var scrapCount: Int?
    var tags: [String]?
    var userDpti: String?
    var userId: String?
    var videos: [URL?]
    
    
    var dictionary: [String: Any] {
        return [
            "board_id" : boardId ?? "",
            "board_title": boardTitle ?? "",
            "bundle_id": bundleId ?? "",
            "category": category ?? "magazine",
            "comment_count": commentCount ?? 0,
            "created_at": createdAt ?? "",
            "description": description ?? "",
            "images": images,
            "links": links,
            "nickname": nickname ?? "",
            "scrap_count": scrapCount ?? 0,
            "tags": tags ?? [],
            "user_dpti": userDpti ?? "",
            "user_id": userId ?? "",
            "videos": videos,
            
        ]
    }
}

// 아티클 카테고리
enum Category {
    case layer
    case magazine
}

// 게시글 종류
enum PostKinds: Int {
    case article = 0
    case information = 1
}
