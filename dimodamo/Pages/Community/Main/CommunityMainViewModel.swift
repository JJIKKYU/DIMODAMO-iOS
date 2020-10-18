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
                title: "VB에서 선미와 눈마주친 순간",
                tags: ["VB스튜디오", "하계인턴", "엔터테인먼트"],
                profile: nil,
                nickname: "사는게쉽지않네",
                scrapCnt: 0,
                commentCnt: 0)
    ]

    var imageLoading = BehaviorRelay<Bool>(value: false)
    var profileLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        
        // profile Download
        storage.child("test/profile.pdf").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
//            let urlString = url.absoluteString
//            print("profileDownloadURL : \(urlString)")
            do {
                let data = try Data(contentsOf: url)
                self.articles[0].profile = data
                self.profileLoading.accept(true)
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        // image Download
        storage.child("test/image.pdf").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            
//            let urlString = url.absoluteString
//            self.articles[0].image = urlString
//            self.imageLoading.accept(true)
            
            do {
                let data = try Data(contentsOf: url)
                self.articles[0].image = data
                self.imageLoading.accept(true)
            } catch let error {
                print(error.localizedDescription)
            }
            
//            print("imageDownloadURL : \(urlString)")
        })
        
        print("### articles[0] = \(self.articles[0])")
    }
}
