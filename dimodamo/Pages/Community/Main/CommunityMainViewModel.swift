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
                scrapCnt: 0,
                commentCnt: 0)
    ]

    var imageLoading = BehaviorRelay<Bool>(value: false)
    var profileLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        
        // profile Download
        storage.child("test/profile.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlString = url.absoluteString
            print("profileDownloadURL : \(urlString)")
            do {
                let data = try Data(contentsOf: url)
                self.articles[0].profile = data
                print("loadingCompleted")
                print("### articles[0] Profile = \(self.articles[0])")
                self.profileLoading.accept(true)
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        // image Download
        storage.child("test/image.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
//            let urlString = url.absoluteString
//            self.articles[0].image = urlString
//            self.imageLoading.accept(true)
            
            do {
                let data = try Data(contentsOf: url)
                self.articles[0].image = data
                print("### articles[0] Image = \(self.articles[0])")
                self.imageLoading.accept(true)
            } catch let error {
                print(error.localizedDescription)
            }
            
//            print("imageDownloadURL : \(urlString)")
        })
        
    }
}
