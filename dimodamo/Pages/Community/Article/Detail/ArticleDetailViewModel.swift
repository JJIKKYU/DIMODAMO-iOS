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
    var userUID: String?
    
    /*
     POSTUID를 main에서 prepare로 전달 받았을 경우에 초기화 시작
     PostKind도 함께 초기화가 되어야 함
     */
    let postUidRelay = BehaviorRelay<String>(value: "")
    let postKindRelay = BehaviorRelay<Int>(value: 0)
    var postDB: String {
        if postKindRelay.value == PostKinds.article.rawValue {
            return "hongik/article/posts/"
        } else if postKindRelay.value == PostKinds.information.rawValue {
            return "hongik/information/posts/"
        }
        return ""
    }
    
    var categoryRelay = BehaviorRelay<String>(value: "")
    var titleRelay = BehaviorRelay<String>(value: "")
    var tagsRelay = BehaviorRelay<[String]>(value: [])
    
    /*
     로딩
     텍스트 및 이미지
     (링크는 알아서 로딩하므로 필요 없음)
     */
    let descriptionLoading = BehaviorRelay<Bool>(value: false)
    let imagesLoading = BehaviorRelay<Bool>(value: false)
    
    
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
     작성 날짜
     */
    let createdAtRelay = BehaviorRelay<String>(value: "")
    
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
    let userNicknameRelay = BehaviorRelay<String>(value: "")
    
    
    /*
     댓글
     */
    // 목록
    let commentsRelay = BehaviorRelay<[Comment]>(value: [])
    // 입력
    let commentInputRelay = BehaviorRelay<String>(value: "")
    var commentDepth: Int = 0
    var commentBundleId = 0.0
    var commentDB: String {
        if postKindRelay.value == PostKinds.article.rawValue {
            return "hongik/article/comments/"
        } else if postKindRelay.value == PostKinds.information.rawValue {
            return "hongik/information/comments/"
        }
        return ""
    }
    var commentUserHeartUidArr: [String] = []
    
    /*
     스크랩
     */
    let scrapCountRelay = BehaviorRelay<Int>(value: 0)
    var scrapUserPostsUidArr: [String] = []
    var scrapUserPostsIndex: Int?
    let isScrapPost = BehaviorRelay<Bool>(value: false)
    
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
                        print("images : \(self!.imagesRelay.value)")
                    }
                    
                    if let videosArr: [String] = data!["videos"] as? [String] {
                        let videosUrlArr: [URL?] = videosArr.map { URL(string: $0) }
                        self?.videosRelay.accept(videosUrlArr)
                    }
                    
                    if let userDpti: String = data!["user_dpti"] as? String {
                        self?.userDptiRelay.accept(userDpti)
                        print("이 글을 쓴 유저의 타입은 \(userDpti)입니다")
                    }
                    
                    if let nickname: String = data!["nickname"] as? String {
                        self?.userNicknameRelay.accept(nickname)
                    }
                    
                    if let createdAt: String = data!["created_at"] as? String {
                        self?.createdAtRelay.accept(createdAt)
                    }
                    
                    if let userId: String = data!["user_id"] as? String {
                        self?.userUID = userId
                    }
                
                    if let scrapCount: Int = data!["scrap_count"] as? Int {
                        self?.scrapCountRelay.accept(scrapCount)
                    }
                    
                    self?.descriptionRelay.accept(data!["description"] as! String)
                    self?.urlLinksRelay.accept(data!["links"] as! [String])
                    self?.commentSetting()
                    self?.userDataSetting()
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
            .order(by: "bundle_order")
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
    
    func userDataSetting() {
        guard let userUID = self.userUID else {
            return
        }
        
        db.collection("users")
            .document("\(userUID)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    // 이미 하트 버튼을 누른 댓글 UID를 가져옴
                    if let heartComments = data!["heartComments"] as? [String] {
                        self?.commentUserHeartUidArr = heartComments
                        print("하트 누른 댓글의 UID : \(self!.commentUserHeartUidArr)")
                    }
                    
                    // 이미 해당 글을 스크랩했는지 UID를 가져옴
                    if let scrapUidArr = data!["scrapPosts"] as? [String] {
                        self?.scrapUserPostsUidArr = scrapUidArr
                        self?.scrapStateSetting()
                    }
                    
                } else {
                    print("게시글에서 유저 정보를 불러오는데 오류가 발생했습니다.")
                }
            }
    
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
        let userNickname: String = userDefaults.string(forKey: "nickname") ?? "익명"
        let userDpti: String = userDefaults.string(forKey: "dpti") ?? "M_TI"
        
        // DocumentID를 미리 불러오기 위해
        
        let document = db.collection("\(commentDB)").document()
        let id: String = document.documentID
        var bundleId: Double?
        
        switch commentDepth {
        // 일반댓글
        case 0:
            bundleId = unixTimestamp
            break
            
        // 대댓글
        // TODO : 답글달기를 누른 bundle_id 세팅
        case 1:
            bundleId = commentBundleId
            break
            
        default:
            break
        }
        
        let comment: Comment = Comment()
        comment.setData(bundle_id: bundleId ?? unixTimestamp,
                        bundle_order: unixTimestamp,
                        comment: self.commentInputRelay.value,
                        comment_id: "\(id)",
                        created_at: "\(strDate)",
                        depth: commentDepth,
                        heart_count: 0,
                        is_deleted: false,
                        nickname: "\(userNickname)",
                        post_id: self.postUidRelay.value,
                        user_id: Auth.auth().currentUser!.uid,
                        user_dpti: "\(userDpti)")
        
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
        guard let userUID = self.userUID else  {
            return
        }
        let userData = db.collection("users").document("\(userUID)")

        var currentHeartCount: Int?
        db.collection("\(commentDB)")
            .document("\(uid)")
            .getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                	
                if let heartCount: Int = data!["heart_count"] as? Int {
                    currentHeartCount = heartCount
                }
                
                guard let heartCount = currentHeartCount else  {
                    return
                }
                
                var removedCommentUID: Bool = false
                for (index, heartCommentUid) in self.commentUserHeartUidArr.enumerated() {
                    if uid == heartCommentUid {
                        print("이미 좋아요를 눌렀으므로 사실상 제거헤야할 것 같습니다.")
                        commentCellDocument.updateData(["heart_count" : heartCount - 1])
                        self.commentUserHeartUidArr.remove(at: index)
                        removedCommentUID = true
                    }
                }
                
                if removedCommentUID == false {
                    // 좋아요를 누른게 없으면 푸쉬
                    commentCellDocument.updateData(["heart_count" : heartCount + 1])
                    self.commentUserHeartUidArr.append(uid)
                }
                
                
                
                // 제거하는데 업데이트데이터는 안될듯
//                print(self.commentUserHeartUidArr)
                userData.updateData(["heartComments" : self.commentUserHeartUidArr])

                
                
            } else {
                print("Documnet does not exist")
            }
        }
    }
    
    func scrapStateSetting() {
        for (index, postUid) in self.scrapUserPostsUidArr.enumerated() {
            print("postUID : \(postUid)")
            print("postUIDRelay : \(postUidRelay.value)")
            if postUid == self.postUidRelay.value {
                print("스크랩한 게시물입니다.")
                isScrapPost.accept(true)
                scrapUserPostsIndex = index
                return
            }
        }
    }
    
    func pressedScrapBtn() {
//        print("전달받았습니다. : \(uid)")
        guard let userUID = self.userUID else  {
            return
        }
        let userData = db.collection("users").document("\(userUID)")
        let documentData = db.collection("\(postDB)").document("\(self.postUidRelay.value)")
        
        var arrIndex: Int?
        
        for (index, uid) in self.scrapUserPostsUidArr.enumerated() {
            if uid == self.postUidRelay.value {
                arrIndex = index
            }
        }
        
        switch self.isScrapPost.value {
        
        // 포스트를 스크랩 하지 않은 상태로, 스크랩을 시도할 경우
        case false:
            let updateScrapCount = self.scrapCountRelay.value + 1
            documentData.updateData(["scrap_count" : updateScrapCount])
            self.scrapUserPostsUidArr.append("\(self.postUidRelay.value)")
            userData.updateData(["scrapPosts" : self.scrapUserPostsUidArr])
            self.isScrapPost.accept(true)
            self.scrapCountRelay.accept(updateScrapCount)
            
            break
        
        // 포스트를 이미 스크랩한 상태로, 스크랩을 취소할 경우
        case true:
            let updateScrapCount = self.scrapCountRelay.value - 1
            documentData.updateData(["scrap_count" : updateScrapCount])
            
            if let arrIndex = arrIndex {
                self.scrapUserPostsUidArr.remove(at: arrIndex)
            }
            userData.updateData(["scrapPosts" : self.scrapUserPostsUidArr])
            self.isScrapPost.accept(false)
            self.scrapCountRelay.accept(updateScrapCount)
            
            break
            
        default:
            break
        }
        
        /*
        db.collection("\(postDB)")
            .document("\(self.postUidRelay.value)")
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    // 포스트를 스크랩 하지 않은 상태로, 스크랩을 시도할 경우
                    if self.isScrapPost.value == false {
                        let updateScrapCount = self.scrapCountRelay.value + 1
                        self.scrapUserPostsUidArr.append("\(self.postUidRelay.value)")
                        
                    }
                    // 포스트를 이미 스크랩한 상태로, 스크랩을 취소할 경우
                    else {
                        if let scrapIndex = self.scrapUserPostsIndex {
                            self.scrapUserPostsUidArr.remove(at: scrapIndex)
                            userData.updateData(["scrapPosts" : self.scrapUserPostsUidArr])
                        }
                    }
                    
                    
                    
                    
                } else {
                    print("document does not exist")
                }
            }
 */
    }
    
    init() {
        
        
    }
    
    
    
    
}
