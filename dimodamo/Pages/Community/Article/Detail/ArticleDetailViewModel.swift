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
    
    /*
     POSTUID를 main에서 prepare로 전달 받았을 경우에 초기화 시작
     */
    let postUidRelay = BehaviorRelay<String>(value: "")
    
    var postUID: String = "41KBHDxkF1LnHNJTZleV"
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
    
    func dataSetting() {
        db.collection("articlePosts/").document("\(self.postUidRelay.value)").getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let data = document.data()
                
                if let imagesArr: [String] = data!["image"] as? [String] {
                    let imagesUrlArr: [URL?] = imagesArr.map { URL(string: $0) }
                    self?.imagesRelay.accept(imagesUrlArr)
                }
                
                if let videosArr: [String] = data!["videos"] as? [String] {
                    let videosUrlArr: [URL?] = videosArr.map { URL(string: $0) }
                    self?.videosRelay.accept(videosUrlArr)
                }
                
                self?.descriptionRelay.accept(data!["description"] as! String)
                self?.urlLinksRelay.accept(data!["links"] as! [String])
//                print("documnetData : \(dataDescription)")
                
            } else {
                print("Documnet does not exist")
            }
        }
    }
    
    init() {
        
                                                    
    }
    
    
    
    
}
