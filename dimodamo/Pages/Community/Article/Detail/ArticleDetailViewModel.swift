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

import SwiftLinkPreview

class ArticleDetailViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let uploadImageCnt: Int = 3
    let postUID: String = "41KBHDxkF1LnHNJTZleV"
    
    var imageRelay = BehaviorRelay<URL>(value: URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/test%2F0XgA8G0aM2FjkVaQ4aE4.png?alt=media&token=c6ddc035-77f5-4f30-9531-4734c167a7a6")!)
    var categoryRelay = BehaviorRelay<String>(value: "")
    var titleRelay = BehaviorRelay<String>(value: "")
    var tagsRelay = BehaviorRelay<[String]>(value: [])
    
    
    var testImageURL: [URL] = [
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/test%2F41KBHDxkF1LnHNJTZleV.png?alt=media&token=116d75da-a1a3-48e4-9af8-0526c2087948")!,
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/articlePosts%2F0XgA8G0aM2FjkVaQ4aE4%2Fimage-1.png?alt=media&token=b29bfc85-42b6-4b46-8d44-bf2fce231961")!,
    ]
    
    /*
     본문 텍스트
     */
    let descriptionRelay = BehaviorRelay<String>(value: "")
    
    /*
     URL link view
     */
    let linksDataRelay = BehaviorRelay<[PreviewResponse]>(value: []) // 링크에 있는 데이터를 해체해 가지고 있음
    let urlLinksRelay = BehaviorRelay<[String]>(value: []) // 링크만 가지고 있음
    static let slp = SwiftLinkPreview(cache: InMemoryCache())
        
    func linkViewSetting() {
        var linksData: [PreviewResponse] = []

        for link in self.urlLinksRelay.value {
            // 캐시 체크
            if let cached = ArticleDetailViewModel.slp.cache.slp_getCachedResponse(url: "\(link)") {
                print("->> cached : \(cached)")
            }
            
            
            ArticleDetailViewModel.slp.previewLink("\(link)",
                            onSuccess: { [self] result in
                                let resultArr = result
                                let linkData: PreviewResponse = PreviewResponse(url: resultArr["url"] as! URL,
                                                                                title: resultArr["title"] as! String,
                                                                                image: resultArr["image"] as! String,
                                                                                icon: resultArr["icon"] as! String)
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
    
    init() {
//        self.linkViewSetting()
        
        //        storage.child("articlePosts/\(postUID)").downloadURL(completion: { url, error in
        //
        //            guard let url = url, error == nil else {
        //                return
        //            }
        //
        //            do {
        //                let data = try Data(contentsOf: url)
        //            }
        //
        //        })
        
        db.collection("articlePosts/").document("\(postUID)").getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let data = document.data()
                
                self?.descriptionRelay.accept(data!["description"] as! String)
                self?.urlLinksRelay.accept(data!["links"] as! [String])
                print("documnetData : \(dataDescription)")
                
            } else {
                print("Documnet does not exist")
            }
        }
                                                    
    }
    
    
    
    
}
