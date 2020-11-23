//
//  HomeViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/23.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxRelay

import SwiftyJSON

import Alamofire

class HomeViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let userUID: String = Auth.auth().currentUser?.uid ?? ""
    
    func myDptiType() -> String {
        let type = UserDefaults.standard.string(forKey: "dpti") ?? "M_TI"
        return type
    }
    
    func myNickname() -> String {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "익명"
        return nickname
    }
    
    /*
     ServiceBanner
     */
    var serviceBannerImgUrlString375Relay = BehaviorRelay<[String]>(value: [])
    var serviceBannerImgUrlString414Relay = BehaviorRelay<[String]>(value: [])
    
    /*
     ArticlePost
     */
    let articleLoading = BehaviorRelay<Bool>(value: false)
    var articlePost: Board?
    
    init() {
        self.loadArticlePost()
        self.loadServiceBanner()
    }
    
    func loadServiceBanner() {
        let serviceBannerJsonURL = "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/service_banner%2Fservice_banner.json?alt=media&token=a8edaa82-7c89-4eb7-b625-ee6705749c1c"
        
        var newImageStringArr375: [String] = []
        var newImageStringArr414: [String] = []
        
        AF.request(serviceBannerJsonURL, method: .get)
            .validate().responseData{ response in
                switch response.result{
                case .success:
                    if let data = response.data {
                        let newJson = JSON(data)
                        
                        if let bannerImgUrlArr = newJson.array {
                            for i in 0..<bannerImgUrlArr.count {
                                // let value = siArray[i]["value"]
                                // values.append(value.stringValue)
                                print(bannerImgUrlArr[i]["banner_image"].stringValue)
                                newImageStringArr375.append(bannerImgUrlArr[i]["banner_image_375"].stringValue)
                                newImageStringArr414.append(bannerImgUrlArr[i]["banner_image_414"].stringValue)
                            }
                        }
                        self.serviceBannerImgUrlString375Relay.accept(newImageStringArr375)
                        self.serviceBannerImgUrlString414Relay.accept(newImageStringArr414)
                    }
                case .failure:
                    print("error : \(response.error!)")
                    
                }
            }
    }
    
    
    func loadArticlePost() {
        // 리로드 할 수도 있으니 비움
        self.articlePost = nil
        self.articleLoading.accept(false)
        
        print("### articleLoading : \(articleLoading.value)")
        
        db.collection("hongik/article/posts")
            .order(by: "bundle_id", descending: true)
            .limit(to: 1)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("아티클 포스트를 가져오는데 오류가 생겼습니다. \(err)")
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
                                                       nickname: nickname,
                                                       scrapCount: scrapCount,
                                                       tags: tags,
                                                       userDpti: userDpti,
                                                       userId: "",
                                                       videos: [])
                        
                        print(articlePost)
                        
                        self.articlePost = articlePost
                        
                        
                        // 로딩 유무 확인
                        if querySnapshot?.documents.count == (index + 1) {
                            articleLoading.accept(true)
                            print("### articleLoading : \(articleLoading.value)")
                        }
                    }
                }
            }
    }
}
