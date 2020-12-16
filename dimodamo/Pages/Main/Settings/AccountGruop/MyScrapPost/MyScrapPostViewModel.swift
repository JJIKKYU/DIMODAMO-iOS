//
//  MyScrapPostViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/17.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxRelay

class MyScrapPostViewModel {
    
    private let db = Firestore.firestore()
    
    var userUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /*
     스크랩한 게시글 어레이
     */
    let scrapArticleListRelay = BehaviorRelay<[ScrapPostModel]>(value: [])
    let scrapInformationListRelay = BehaviorRelay<[ScrapPostModel]>(value: [])
    
    /*
     로딩
     */
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    /*
     현재 보여지고 있는 스크랩 종류
     */
    let scrapKinds = BehaviorRelay<PostKinds>(value: .article)
    
    /*
     스크랩한 게시글 타이틀
     */
    var titleUidArr: [String] = []
    
    init() {
        settingScrapPost()
    }
    
    func settingScrapPost() {
        guard let uid: String = self.userUID else {
            return
        }
        
        db.collection("users_scrap_posts")
            .document("\(uid)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    // 이미 해당 글을 스크랩했는지 map을 먼저 가져옴
                    if let scrapList = data!["scrap_list"] as? [String: [String: Any]] {
                        
                        // 그 스크랩 포스트 UID로 가져올 경우 값이 있으면
                        print(scrapList)
                        
                        
                        
                        // (아티클, 디모 아트보드)일 경우
                        print("type = \(scrapList.keys)")
                        
                        var articlePostList: [ScrapPostModel] = []
                        var informationPostList: [ScrapPostModel] = []
                        
                        for key in scrapList.keys {
                            let scrapPost = ScrapPostModel()
                            let model = scrapList[key]
                            
                            scrapPost.uid = key
                            
                            if let author =  model?["author"] as? String {
                                scrapPost.author = author
                            }
                            
                            if let author_type = model?["author_type"] as? String {
                                scrapPost.author_type = author_type
                            }
                            
                            if let created_at = model?["created_at"] as? Double {
                                scrapPost.createdAt = created_at
                            }
                            
                            if let title = model?["title"] as? String {
                                scrapPost.title = title
                            }
                            
                            if let type = model?["type"] as? Int {
                                scrapPost.type = type
                            }
                            
                            if let thumb_image = model?["thumb_image"] as? String {
                                scrapPost.thumb_image = thumb_image
                            }
                            
                            if let tags = model?["tags"] as? [String] {
                                scrapPost.tags = tags
                            }
                            
                            // 디모아트보드, Article, 디모픽일 경우
                            if scrapPost.type == PostKinds.article.rawValue {
                                articlePostList.append(scrapPost)
                            }
                            // 인포메이션 (기본게시판형태)일 경우
                            else if scrapPost.type == PostKinds.information.rawValue {
                                informationPostList.append(scrapPost)
                            }
                        }
                        
                        articlePostList = articlePostList.sorted(by: { $0.createdAt! < $1.createdAt!})
                        self?.scrapArticleListRelay.accept(articlePostList)
                        self?.scrapInformationListRelay.accept(informationPostList)
                        self?.isLoadingRelay.accept(true)
                    }
                    
                }
                else {
                    print("스크랩 DB를 가져오는데 오류가 발생했습니다.")
                }
            }
    }
}


// MARK: - Model

class ScrapPostModel {
    var uid: String?
    var author: String?
    var author_type: String?
    var thumb_image: String?
    var title: String?
    var tags: [String]?
    var type: Int?
    var createdAt: Double?
}
