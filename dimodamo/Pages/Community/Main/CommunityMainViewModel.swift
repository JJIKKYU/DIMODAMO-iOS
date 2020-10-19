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
    
    var articles: [Article] = [
        Article(image: nil,
                category: .magazine,
                title: "VB에서 선미와 눈마주친 순간^_",
                tags: ["VB사랑", "인턴스", "엔따"],
                profile: nil,
                nickname: "사는게쉽지않네",
                author: "",
                scrapCnt: 0,
                commentCnt: 0),
        Article(image: nil,
                category: .magazine,
                title: "VB에서 선미와 눈마주친 순간^_",
                tags: ["VB사랑", "인턴스", "엔따"],
                profile: nil,
                nickname: "사는게쉽지않네",
                author: "",
                scrapCnt: 0,
                commentCnt: 0)
    ]
    
    var imageLoading = BehaviorRelay<Bool>(value: false)
    var profileLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        // Article Setting
        // TODO : 정렬해서 가져와야함
        profileDownload()
        
        db.collection("articlePosts").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("아티클 포스트를 가져오는데 오류가 생겼습니다. \(err)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    
                    self.articles[index].title =  (document.data()["title"] as! String)
                    self.articles[index].tags =  (document.data()["tags"] as! [String])
                    self.articles[index].nickname = (document.data()["nickname"] as! String)
                    self.articles[index].scrapCnt = (document.data()["scrapCnt"] as! Int)
                    self.articles[index].commentCnt = (document.data()["commentCnt"] as! Int)
                    self.imageDownlad(postUID: document.documentID, index: index)
                    
                    
                    print("\(document.documentID) => \(document.data()["title"])")
                }
            }
        }
        
        
        
        
    }
    
    func profileDownload() {
        // profile Download
        storage.child("test/profile.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
//            let urlString = url.absoluteString
//            print("profileDownloadURL : \(urlString)")
            self.articles[0].profile = url
            print("loadingCompleted")
//            print("### articles[0] Profile = \(self.articles[0])")
            self.profileLoading.accept(true)
            
        })
    }
    
    func imageDownlad(postUID: String, index: Int) {
        // image Download
        storage.child("test/\(postUID).png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlString = url.absoluteString
            print("imageDownloadURL : \(urlString)")
            self.articles[index].image = url
            self.imageLoading.accept(true)
        })
        
    }
}
