//
//  ArticleViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/28.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase
import FirebaseFirestore

class ArticleViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    /*
     Post
     */
    
    let postsRelay = BehaviorRelay<[Board]>(value: [])
    var articlePosts: [Board] = []
    var postDB: String {
        return "hongik/article/posts/"
    }
    
    /*
     블럭 유저 데이터
     */
    var blockedUserMap: [String:Bool] = [:]
    
    /*
     Sorting
     */
    let sortingOrder = BehaviorRelay<Sort>(value: .date) // 기본은 Date 순으로
    var sortingOrderFieldString: String {
        switch sortingOrder.value {
        case .date:
            return "bundle_id"
            
        case .scrap:
            return "scrap_count"
            
        case .comment:
            return "comment_count"
        }
    }
    
    /*
     Loading
     */
    let postsLoading = BehaviorRelay<Bool>(value: false)
    
    func postDataSetting() {
        print("################ 호출")
        
        // 리로드 될 수도 있으므로, 함수를 호출할 때마다 false 선택
        postsLoading.accept(false)
        self.articlePosts = []
        
        db.collection("\(postDB)")
//            .order(by: "\(sortingOrderFieldString)")
            .order(by: "\(sortingOrderFieldString)", descending: true)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("아티클 포스트를 가져오는데 오류가 발생했습니다 \(err.localizedDescription)")
                } else {
                    for (index, document) in querySnapshot!.documents.enumerated() {
                        
                        guard let userId: String = document.data()["user_id"] as? String else {
                            return
                        }
                        
                        // 차단한 유저 체크
                        let isUserBlocked = BlockUserManager.blockedUserMap[userId]
                        if isUserBlocked == true {
                            print("차단한 유저의 게시글입니다!!!!!!!!!!!!!")
                            
                            // 로딩 유무 확인
                            if querySnapshot?.documents.count == (index + 1) {
                                postsLoading.accept(true)
                            }
                            
                            continue
                        }
                        
                        let boardId = (document.data()["board_id"] as? String) ?? ""
                        let boardTitle = (document.data()["board_title"] as? String) ?? ""
                        let bundleId = (document.data()["bundle_id"] as? Double) ?? 0
                        let commentCount = (document.data()["comment_count"] as? Int) ?? 0
                        let nickname = (document.data()["nickname"] as? String) ?? ""
                        let scrapCount = (document.data()["scrap_count"] as? Int) ?? 0
                        let tags = (document.data()["tags"] as? [String]) ?? []
                        let userDpti = (document.data()["user_dpti"] as? String) ?? ""
                        
                        // [String] Image를 [URL?] Image로 변환
                        var images: [String]? = []
                        if let documentImageString: [String] = document.data()["images"] as? [String] {
//                            let documnetImageURL: [URL?] = documentImageString.map { URL(string: $0) }
                            images = documentImageString
                        }
                        
                        
                        let articlePost: Board = Board(boardId: boardId,
                                                       boardTitle: boardTitle,
                                                       bundleId: bundleId,
                                                       category: "",
                                                       commentCount: commentCount,
                                                       createdAt: "",
                                                       description: "",
                                                       images: images,
                                                       links: [],
                                                       nickname: nickname,
                                                       scrapCount: scrapCount,
                                                       tags: tags,
                                                       userDpti: userDpti,
                                                       userId: "",
                                                       videos: [])
                        
                        print(articlePost)
                        
                        self.articlePosts.append(articlePost)
                        
                        
                        // 로딩 유무 확인
                        if querySnapshot?.documents.count == (index + 1) {
                            postsLoading.accept(true)
                        }
                    }
                }
            }
    }
    
    init() {
        
        let blockManager = BlockUserManager()
        blockManager.blockUserCheck { value in
            self.blockedUserMap = value
        }
    }
}
