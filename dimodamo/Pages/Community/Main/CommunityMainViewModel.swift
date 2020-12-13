//
//  CommunityMainViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class CommunityMainViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    /*
     로딩할 아티클, 인포메이션 포스트 개수
     */
    let loadMaxCount: Int = 4
    
    /*
     블럭 유저 데이터
     */
    var blockedUserMap: [String: [String: String]] = [:]
    
    var articlePosts: [Board] = []
    var informationPosts: [Board] = []
    
    let articleLoading = BehaviorRelay<Bool>(value: false)
    let informationLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        let blockManager = BlockUserManager()
        blockManager.blockUserCheck { value in
            self.blockedUserMap = value
        }
    }
    
    func loadArticlePost() {
        // 리로드 할 수도 있으니 비움
        self.articlePosts = []
        self.articleLoading.accept(false)
        
        print("### articleLoading : \(articleLoading.value)")
        
        db.collection("hongik/article/posts")
            .order(by: "is_deleted")
            .whereField("is_deleted", isNotEqualTo: true)
            .order(by: "bundle_id", descending: true)
            .limit(to: 6)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("아티클 포스트를 가져오는데 오류가 생겼습니다. \(err)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    guard let userId: String = document.data()["user_id"] as? String else {
                        return
                    }
                    let isUserBlocked = BlockUserManager.blockedUserMap[userId]
                    if (isUserBlocked != nil) == true {
                        print("차단한 유저의 게시글입니다!!!!!!!!!!!!!")
                        
                        // 로딩 유무 확인
                        if querySnapshot?.documents.count == (index + 1) {
                            articleLoading.accept(true)
                            print("### articleLoading : \(articleLoading.value)")
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
//                        let documnetImageURL: [URL?] = documentImageString.map { URL(string: $0) }
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
                                                       isDeleted: false,
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
                        articleLoading.accept(true)
                        print("### articleLoading : \(articleLoading.value)")
                    }
                }
            }
        }
    }
    
    func loadInformationPost() {
        // 리로드 할 수도 있으니 비움
        self.informationPosts = []
        self.informationLoading.accept(false)
        
        // Article Setting
        // TODO : 정렬해서 가져와야함
        print("### informationLoading : \(informationLoading.value)")
        
        db.collection("hongik/information/posts")
            .order(by: "is_deleted")
            .whereField("is_deleted", isNotEqualTo: true)
            .order(by: "bundle_id", descending: true)
            .limit(to: 6)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("인포메이션 포스트를 가져오는데 오류가 생겼습니다. \(err)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    
                    guard let userId: String = document.data()["user_id"] as? String else {
                        return
                    }
                    let isUserBlocked = BlockUserManager.blockedUserMap[userId]
                    if (isUserBlocked != nil) == true {
                        print("차단한 유저의 게시글입니다!!!!!!!!!!!!!")
                        
                        // 로딩 유무 확인
                        if querySnapshot?.documents.count == (index + 1) {
                            informationLoading.accept(true)
                            print("### informationLoading : \(informationLoading.value)")
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
                    
                    let informationPost: Board = Board(boardId: boardId,
                                                       boardTitle: boardTitle,
                                                       bundleId: bundleId,
                                                       category: "",
                                                       commentCount: commentCount,
                                                       createdAt: "",
                                                       description: "",
                                                       images: [],
                                                       links: [],
                                                       isDeleted: false,
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
                        print("### informationLoading : \(informationLoading.value)")
                    }
                }
            }
            
        }
    }
//    func profileDownload() {
//        // profile Download
//        storage.child("test/profile.png").downloadURL(completion: { url, error in
//            guard let url = url, error == nil else {
//                return
//            }
//
////            let urlString = url.absoluteString
////            print("profileDownloadURL : \(urlString)")
//            self.articles[0].profile = url
//            print("loadingCompleted")
////            print("### articles[0] Profile = \(self.articles[0])")
//            self.profileLoading.accept(true)
//
//        })
//    }
    
//    func imageDownlad(postUID: String, index: Int) {
//        // image Download
//        storage.child("test/\(postUID).jpg").downloadURL(completion: { url, error in
//            guard let url = url, error == nil else {
//                return
//            }
//            let urlString = url.absoluteString
//            print("imageDownloadURL : \(urlString)")
//            self.articles[index].image = url
//            self.imageLoading.accept(true)
//        })
//
//    }
}
