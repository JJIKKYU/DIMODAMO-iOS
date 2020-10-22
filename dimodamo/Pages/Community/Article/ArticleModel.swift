//
//  Article.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/18.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

// 아티클에 필요한 모델
struct Article {
    var uid: String?
    var image: [URL?]
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
