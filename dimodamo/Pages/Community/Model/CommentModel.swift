//
//  CommentModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

class Comment {
    var bundle_id: Int?
    var bundle_order: Int?
    var comment: String?
    var comment_id: String?
    var created_at: String? // Timestamp로 변경
    var depth: Int?
    var is_deleted: Bool?
    var nickname: String?
    var post_id: String?
    var user_id: String?
    
    init() {
        
    }
    
    func setData(bundle_id: Int, bundle_order: Int, comment: String, comment_id: String, created_at: String,
                 depth: Int, is_deleted: Bool, nickname: String, post_id: String, user_id: String) {
        self.bundle_id = bundle_id
        self.bundle_order = bundle_order
        self.comment = comment
        self.comment_id = comment_id
        self.created_at = created_at
        self.depth = depth
        self.is_deleted = is_deleted
        self.nickname = nickname
        self.post_id = post_id
        self.user_id = user_id
    }
    
    func settingDataFromDocumentData(data: [String: Any]) {
        if let bundle_id: Int = data["bundle_id"] as? Int {
            self.bundle_id = bundle_id
        }
        
        if let bundle_order: Int = data["bundle_order"] as? Int {
            self.bundle_order = bundle_order
        }
        
        if let commentData: String = data["comment"] as? String {
            self.comment = commentData
        }
        
        if let comment_id: String = data["comment_id"] as? String {
            self.comment_id = comment_id
        }
        
        // create_at은 일단 생략
//                    if let
        
        if let comment_depth: Int = data["comment_depth"] as? Int {
            self.depth = comment_depth
        }
        
        if let is_deleted: Bool = data["is_deleted"] as? Bool {
            self.is_deleted = is_deleted
        }
        
        if let nickname: String = data["nickname"] as? String {
            self.nickname = nickname
        }
        
        if let post_id: String = data["post_id"] as? String {
            self.post_id = post_id
        }
        
        if let user_id: String = data["user_id"] as? String {
            self.user_id = user_id
        }
    }
}
