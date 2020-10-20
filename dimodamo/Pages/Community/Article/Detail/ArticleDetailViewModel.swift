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

class ArticleDetailViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    let uploadImageCnt: Int = 3
    let postUID: String = "0XgA8G0aM2FjkVaQ4aE4"
    
    var imageRelay = BehaviorRelay<URL>(value: URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/test%2F0XgA8G0aM2FjkVaQ4aE4.png?alt=media&token=c6ddc035-77f5-4f30-9531-4734c167a7a6")!)
    var categoryRelay = BehaviorRelay<String>(value: "")
    var titleRelay = BehaviorRelay<String>(value: "")
    var tagsRelay = BehaviorRelay<[String]>(value: [])
    
    
    var testImageURL: [URL] = [
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/test%2F41KBHDxkF1LnHNJTZleV.png?alt=media&token=116d75da-a1a3-48e4-9af8-0526c2087948")!,
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dimodamo-f9e85.appspot.com/o/articlePosts%2F0XgA8G0aM2FjkVaQ4aE4%2Fimage-1.png?alt=media&token=b29bfc85-42b6-4b46-8d44-bf2fce231961")!,
    ]
    
    init() {
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
    }
    
    
}
