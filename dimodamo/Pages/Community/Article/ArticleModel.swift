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
    var image: Data?
    var category: Category?
    var title: String?
    var tags: [String]?
    var profile: Data?
    var nickname: String?
    var scrapCnt: Int?
    var commentCnt: Int?
}


// 아티클 카테고리
enum Category {
    case magazine
}
