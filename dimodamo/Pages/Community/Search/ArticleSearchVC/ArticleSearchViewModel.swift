//
//  ArticleSearchViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/31.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class ArticleSearchViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    var searchArticlePosts: [Board] = []
    let searchLoading = BehaviorRelay<Bool>(value: false)
    let searchKeyword = BehaviorRelay<String>(value: "")
    
    func articleSearch() {
        print("검색 키워드 : \(searchKeyword.value)")
        
        db.collection("hongik").document("article").collection("posts")
            .whereField("board_title", isGreaterThanOrEqualTo: "\(self.searchKeyword.value)")
//            .order(by: "board_title")
//            .start(at: ["\(self.searchKeyword.value)"])
//            .end(at: "블랙핑크" + "\uf8ff")
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("검색에 실패했습니다.")
                } else {
                    for (index, document) in querySnapshot!.documents.enumerated() {
                        
                        let title = document.data()["board_title"] as! String
                        print("title : \(title)")
//                        print(document.data())
                        print(index)
                    }
                }
                
                print("검색완료")
            }
    }
    
    init() {
        
        
        
    }
}
