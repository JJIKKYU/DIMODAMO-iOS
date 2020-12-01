//
//  InformationViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class InformationViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    var informationPosts: [Board] = []
    let pageSize: Int = 3 // 한 번에 로딩할 페이지 개수
    var cursor: DocumentSnapshot? // 마지막 도큐먼트 -> 여기서부터 읽을거야
    let informationLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        db.collection("hongik/information/posts")
            .order(by: "bundle_id", descending: true)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("인포메이션 포스트를 가져오는데 오류가 생겼습니다. \(err)")
            } else {
                
                // TODO : Pagination 작업할 것
                
                // pageSize보다 작으면 다 읽음
                if querySnapshot!.count < pageSize {
                    
                }
                // pageSize보다 크면 나눠서 읽음
                else {
                    
                    self.cursor = querySnapshot?.documents.last
                }
                
                for (index, document) in querySnapshot!.documents.enumerated() {
                    let boardId = (document.data()["board_id"] as? String) ?? ""
                    let boardTitle = (document.data()["board_title"] as? String) ?? ""
                    let bundleId = (document.data()["bundle_id"] as? Double) ?? 0
                    let commentCount = (document.data()["comment_count"] as? Int) ?? 0
                    let nickname = (document.data()["nickname"] as? String) ?? ""
                    let scrapCount = (document.data()["scrap_count"] as? Int) ?? 0
                    let tags = (document.data()["tags"] as? [String]) ?? []
                    let userDpti = (document.data()["user_dpti"] as? String) ?? ""
                    
                    let informationPost: Board = Board(boardId: boardId,
                                                       boardTitle: boardTitle,
                                                       bundleId: bundleId,
                                                       category: "",
                                                       commentCount: commentCount,
                                                       createdAt: "",
                                                       description: "",
                                                       images: [],
                                                       links: [],
                                                       nickname: nickname,
                                                       scrapCount: scrapCount,
                                                       tags: tags,
                                                       userDpti: userDpti,
                                                       userId: "",
                                                       videos: [])
                    
                    self.informationPosts.append(informationPost)
                    print(informationPost)
                    
                    // 로딩 유무 확인
                    if querySnapshot?.documents.count == (index + 1) {
                        informationLoading.accept(true)
                    }
                }
            }
            
        }
    }
}
