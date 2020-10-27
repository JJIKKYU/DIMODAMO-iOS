//
//  ArticleDetailViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/19.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase
import FirebaseFirestore

import SwiftLinkPreview

class ArticleDetailViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    /*
     POSTUID를 main에서 prepare로 전달 받았을 경우에 초기화 시작
     PostKind도 함께 초기화가 되어야 함
     */
    let postUidRelay = BehaviorRelay<String>(value: "")
    let postKindRelay = BehaviorRelay<Int>(value: -1)
    var postDB: String {
        if postKindRelay.value == PostKinds.article.rawValue {
            return "articlePosts/"
        } else if postKindRelay.value == PostKinds.information.rawValue {
            return "hongik/information/posts/"
        }
        return ""
    }
    
    var categoryRelay = BehaviorRelay<String>(value: "")
    var titleRelay = BehaviorRelay<String>(value: "")
    var tagsRelay = BehaviorRelay<[String]>(value: [])
    
    /*
     이미지
     */
    let thumbnailImageRelay = BehaviorRelay<URL?>(value: URL(string: ""))
    let imagesRelay = BehaviorRelay<[URL?]>(value: [])
    
    /*
     본문 첨부 영상
     */
    let videosRelay = BehaviorRelay<[URL?]>(value: [])
    
    /*
     본문 텍스트
     */
    let descriptionRelay = BehaviorRelay<String>(value: "")
    
    /*
     URL link view
     */
    let linksDataRelay = BehaviorRelay<[PreviewResponse]>(value: []) // 링크에 있는 데이터를 해체해 가지고 있음
    let urlLinksRelay = BehaviorRelay<[String]>(value: []) // 링크만 가지고 있음
    var loadingAnimationViewIsInstalled: Bool = false
    static let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    /*
     유저 프로필
     */
    let userDptiRelay = BehaviorRelay<String>(value: "")
    
    
    /*
     댓글
     */
    // 목록
    let commentsRelay = BehaviorRelay<[Comment]>(value: [])
    // 입력
    let commentInputRelay = BehaviorRelay<String>(value: "")
    var commentDB: String {
        if postKindRelay.value == PostKinds.article.rawValue {
            return "hongik/article/comments/"
        } else if postKindRelay.value == PostKinds.information.rawValue {
            return "hongik/information/comments/"
        }
        return ""
    }
    
    func linkViewSetting() {
        var linksData: [PreviewResponse] = []
        
        for link in self.urlLinksRelay.value {
            // 캐시 체크
            if let cached = ArticleDetailViewModel.slp.cache.slp_getCachedResponse(url: "\(link)") {
                print("->> cached : \(cached)")
            }
            
            
            ArticleDetailViewModel.slp
                .previewLink("\(link)",
                             onSuccess: { [self] result in
                                let resultArr = result
                                let linkData: PreviewResponse =
                                    PreviewResponse(url: (resultArr["url"] as? URL) ?? URL(string: "dimodamo.com")!,
                                                    title: resultArr["title"] as? String ?? "",
                                                    image: resultArr["image"] as? String ?? "",
                                                    icon: resultArr["icon"] as? String ?? ""
                                    )
                                linksData.append(linkData)
                                
                                // 모든 데이터가 다 들어갔을 때 마지막 한 번만 호출
                                if urlLinksRelay.value.count == linksData.count {
                                    self.linksDataRelay.accept(linksData)
                                    //                                    print("ulrLinks.count = \(urlLinks.count), linksData = \(linksData.count)")
                                }
                             }, onError: { error in
                                print("\(error)")
                             })
        }
    }
    
    func dataSetting() {
        print("POSTURL : \(self.postDB), POSTUID : \(self.postUidRelay.value)")
        
        db.collection("\(self.postDB)")
            .document("\(self.postUidRelay.value)")
            .getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
                    
                    let data = document.data()
                    
                    if let imagesArr: [String] = data!["images"] as? [String] {
                        let imagesUrlArr: [URL?] = imagesArr.map { URL(string: $0) }
                        self?.imagesRelay.accept(imagesUrlArr)
                    }
                    
                    if let videosArr: [String] = data!["videos"] as? [String] {
                        let videosUrlArr: [URL?] = videosArr.map { URL(string: $0) }
                        self?.videosRelay.accept(videosUrlArr)
                    }
                    
                    if let userDpti: String = data!["user_dpti"] as? String {
                        self?.userDptiRelay.accept(userDpti)
                        print("이 글을 쓴 유저의 타입은 \(userDpti)입니다")
                    }
                    
                    self?.descriptionRelay.accept(data!["description"] as! String)
                    self?.urlLinksRelay.accept(data!["links"] as! [String])
                    self?.commentSetting()
                    //                print("documnetData : \(dataDescription)")
                    
                } else {
                    print("Documnet does not exist")
                }
            }
    }
    
    func commentSetting() {
        db.collection("\(self.commentDB)")
            .whereField("post_id", isEqualTo: postUidRelay.value)
            .whereField("is_deleted", isEqualTo: false)
            .order(by: "bundle_id")
            .getDocuments(completion: { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("댓글을 가져오는데 실패했습니다. \(err.localizedDescription)")
                    return
                }
                
                // 코멘트를 담을 배열 생성
                var comments: [Comment] = []
                
                // 댓글을 성공적으로 가져왔을 경우
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    let comment: Comment = Comment()
                    comment.settingDataFromDocumentData(data: data)
                    comments.append(comment)
                    
                    print("setting완료 : \(String(describing: comment.comment))")
                }
                
                self?.commentsRelay.accept(comments)
            })
    }
    
    func commentInput() {
        if commentInputRelay.value.count == 0 { return }
        
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        
        // 유저 디폹트에서 닉네임을 불러옴
        let userDefaults = UserDefaults.standard
        let nickname: String = userDefaults.string(forKey: "nickname") ?? "익명"
        
        // DocumentID를 미리 불러오기 위해
        
        let document = db.collection("\(commentDB)").document()
        let id: String = document.documentID
        
        let comment: Comment = Comment()
        comment.setData(bundle_id: unixTimestamp,
                        bundle_order: unixTimestamp,
                        comment: self.commentInputRelay.value,
                        comment_id: "\(id)",
                        created_at: "\(strDate)",
                        depth: 0,
                        heart_count: 0,
                        is_deleted: false,
                        nickname: "\(nickname)",
                        post_id: self.postUidRelay.value,
                        user_id: Auth.auth().currentUser!.uid)
        
        document.setData(comment.dictionary) {
            err in
            if let err = err {
                print("error adding document: \(err.localizedDescription)")
            } else {
                print("Document added with ID: \(id)")
                self.commentSetting()
                
            }
        }
        
    }
    
    func pressedCommentHeart(uid: String) {
        print("전달받았습니다 : \(uid)")
        
        let commentCellDocument = db.collection("\(commentDB)").document("\(uid)")

        var currentHeartCount: Int?
        db.collection("\(commentDB)")
            .document("\(uid)")
            .getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let heartCount: Int = data!["heart_count"] as? Int {
                    currentHeartCount = heartCount
                }
                
                if let heartCount = currentHeartCount {
                    commentCellDocument.updateData(["heart_count" : heartCount + 1])
                }
                
                
            } else {
                print("Documnet does not exist")
            }
        }
    }
    
    init() {
        
        
    }
    
    
    
    
}
