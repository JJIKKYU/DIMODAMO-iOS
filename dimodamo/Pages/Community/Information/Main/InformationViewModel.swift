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
    let pageSize: Int = 10 // 한 번에 로딩할 페이지 개수
    var cursor: DocumentSnapshot? // 마지막 도큐먼트 -> 여기서부터 읽을거야
    var fetchingMore: Bool = false
    let informationLoading = BehaviorRelay<Bool>(value: false)
    
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
    
    init() {
        self.paginateData()
    }
    
    /*
     페이지네이션한 게시글 모거록
     */
    func paginateData() {
        fetchingMore = true
        
        var query: Query!
        
        if self.informationPosts.isEmpty {
            query = db.collection("hongik/information/posts")
                .order(by: "\(sortingOrderFieldString)", descending: true)
                .limit(to: pageSize)
        } else {
            query = db.collection("hongik/information/posts")
                .order(by: "\(sortingOrderFieldString)", descending: true)
                .start(afterDocument: cursor!)
                .limit(to: pageSize)
        }
        
        query.getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("인포메이션 포스트를 가져오는데 오류가 생겼습니다. \(err)")
            } else if querySnapshot!.isEmpty {
                self.fetchingMore = false
                informationLoading.accept(true)
                return
            } else {
                
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
                    
                    self.cursor = querySnapshot?.documents.last
                    
                    // 로딩 유무 확인
                    if querySnapshot?.documents.count == (index + 1) {
                        informationLoading.accept(true)
                        fetchingMore = false
                    }
                }
            }
            
        }
    }
    
    /*
     정렬 기준을 바꾸면 다시 로딩 해야하므로
     */
    func sortingChange() {
        // 먼저 기존에 로딩된 InformationPosts를 모두 비움
        self.informationPosts = []
        // 다시 data 세팅
        self.paginateData()
    }
    
    /*
     글쓰기가 가능한지 체크
     */
    func createPostisAvailable() -> Bool {
        let myType = UserDefaults.standard.string(forKey: "dpti") ?? "DD"
        
        // 아직 DPTI를 진행하지 않았을 경우
        if myType == "DD" {
            print("DPTI가 '\(myType)' 이므로 글쓰기가 제한됩니다.")
            return false
        }
        // DPTI를 진행했을 경우
        else {
            return true
        }
    }
}
