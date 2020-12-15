//
//  MyAlarmViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class MyAlarmViewModel {
    
    private let db = Firestore.firestore()
    
    var myUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    let noticeRelay = BehaviorRelay<Bool>(value: false)
    let hotContentsRelay = BehaviorRelay<Bool>(value: false)
    let commentRelay = BehaviorRelay<Bool>(value: false)
    let ofCommentRelay = BehaviorRelay<Bool>(value: false)
    let documentRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        self.loadingUserData()
    }
    
    func loadingUserData() {
        guard let uid: String = myUID else {
            return
        }
        
        db.collection("FcmId")
            .document("\(uid)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let notice = data!["notice"] as? Bool {
                        self?.noticeRelay.accept(notice)
                    }
                    
                    if let hotContents = data!["hotContents"] as? Bool {
                        self?.hotContentsRelay.accept(hotContents)
                    }
                    
                    if let comment = data!["comment"] as? Bool {
                        self?.commentRelay.accept(comment)
                    }
                    
                    if let ofComment = data!["ofComment"] as? Bool {
                        self?.ofCommentRelay.accept(ofComment)
                    }
                    
                    if let document = data!["document"] as? Bool {
                        self?.documentRelay.accept(document)
                    }
                    
                    print("\(self!.noticeRelay.value), \(self!.hotContentsRelay.value)")
                    self?.loadingRelay.accept(true)
                } else {
                    print("프로필에서 유저 데이터를 초기화하지 못했습니다.")
                }
                
                
            }
    }
    
    // 전체 선택을 할 경우
    func setAllAlarmChange(all: Bool) {
        guard let uid: String = myUID else {
            return
        }
        
        let userFcmDocument = db.collection("FcmId").document("\(uid)")
        
        self.noticeRelay.accept(all)
        self.hotContentsRelay.accept(all)
        self.commentRelay.accept(all)
        self.ofCommentRelay.accept(all)
        self.documentRelay.accept(all)
        
        userFcmDocument.setData([
                                    "notice" : all,
                                    "hotContents" : all,
                                    "comment" : all,
                                    "ofComment": all,
                                    "document" : all],
                                   merge: true
        )
    }

    // 개별로 선택할 경우
    func setAlarmChange(notice: Bool, hotContents: Bool, comment: Bool, ofComment: Bool, document: Bool) {
        guard let uid: String = myUID else {
            return 
        }
        
        let userFcmDocument = db.collection("FcmId").document("\(uid)")
        
        userFcmDocument.setData([
                                    "notice" : notice,
                                    "hotContents" : hotContents,
                                    "comment" : comment,
                                    "ofComment": ofComment,
                                    "document" : document],
                                   merge: true
        )
        
    }
}

// 알림 종류
enum AlarmKinds: String {
    case all = "all"
    case notice = "notice"
    case hotContents = "hotContents"
    case comment = "comment"
    case ofComment = "ofComment"
    case document = "document"
}
