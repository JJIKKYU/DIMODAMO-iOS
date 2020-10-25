//
//  CommentModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

class Comment : Codable {
    var bundleId: Double?
    var bundleOrder: Double?
    var comment: String?
    var commentId: String?
    var createdAt: String? // Timestamp로 변경
    var depth: Int?
    var heartCount: Int?
    var isDeleted: Bool?
    var nickname: String?
    var postId: String?
    var userId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case bundleOrder = "bundle_order"
        case comment
        case commentId = "comment_id"
        case createdAt = "created_at"
        case depth
        case heartCount = "heart_count"
        case isDeleted = "is_deleted"
        case nickname
        case postId = "postId"
        case userId = "userId"
        
    }
    
    var dictionary: [String: Any] {
        return [
            "bundle_id": bundleId ?? 0,
            "bundle_order" : bundleOrder ?? 0,
            "comment": comment ?? "",
            "comment_id": commentId ?? "",
            "created_at": createdAt ?? "",
            "depth": depth ?? 0,
            "heart_count": heartCount ?? 0,
            "is_deleted": isDeleted ?? false,
            "nickname": nickname ?? "",
            "post_id": postId ?? "",
            "user_id": userId ?? ""
        ]
    }
    
    //    required init(from decoder: Decoder) throws {
    //        let values = try decoder.container(keyedBy: CodingKeys.self)
    //        bundleId = (try? values.decode(Int.self, forKey: .bundleId)) ?? 0
    //        bundleOrder = (try? values.decode(Int.self, forKey: .bundleOrder)) ?? 0
    //        comment = (try? values.decode(String.self, forKey: .comment)) ?? ""
    //        commentId = (try? values.decode(String.self, forKey: .commentId)) ?? ""
    //        // 수정 예정
    //        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
    //        depth = (try? values.decode(Int.self, forKey: .depth)) ?? 0
    //        isDeleted = (try? values.decode(Bool.self, forKey: .isDeleted)) ?? false
    //        nickname = (try? values.decode(String.self, forKey: .nickname)) ?? ""
    //        postId = (try? values.decode(String.self, forKey: .postId)) ?? ""
    //        userId = (try? values.decode(String.self, forKey: .userid)) ?? ""
    //    }
    
    func setData(bundle_id: Double, bundle_order: Double, comment: String, comment_id: String, created_at: String,
                 depth: Int, heart_count: Int, is_deleted: Bool, nickname: String, post_id: String, user_id: String) {
        self.bundleId = bundle_id
        self.bundleOrder = bundle_order
        self.comment = comment
        self.commentId = comment_id
        self.createdAt = created_at
        self.depth = depth
        self.heartCount = heart_count
        self.isDeleted = is_deleted
        self.nickname = nickname
        self.postId = post_id
        self.userId = user_id
    }
    
    func settingDataFromDocumentData(data: [String: Any]) {
        if let bundle_id: Double = data["bundle_id"] as? Double {
            self.bundleId = bundle_id
        }
        
        if let bundle_order: Double = data["bundle_order"] as? Double {
            self.bundleOrder = bundle_order
        }
        
        if let commentData: String = data["comment"] as? String {
            self.comment = commentData
        }
        
        if let comment_id: String = data["comment_id"] as? String {
            self.commentId = comment_id
        }
        
        if let created_at: String = data["created_at"] as? String {
            self.createdAt = created_at
        }
        
        if let comment_depth: Int = data["comment_depth"] as? Int {
            self.depth = comment_depth
        }
        
        if let heart_count: Int = data["heart_count"] as? Int {
            self.heartCount = heart_count
        }
        
        if let is_deleted: Bool = data["is_deleted"] as? Bool {
            self.isDeleted = is_deleted
        }
        
        if let nickname: String = data["nickname"] as? String {
            self.nickname = nickname
        }
        
        if let post_id: String = data["post_id"] as? String {
            self.postId = post_id
        }
        
        if let user_id: String = data["user_id"] as? String {
            self.userId = user_id
        }
    }
}
