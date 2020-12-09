//
//  ApplicationViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/10.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

class UserData {
    private let db = Firestore.firestore()

    /*
     user의 report 횟수를 가져오는 비동기 함수
     
     // 사용법
     let user = UserData()
     user.testReportUser { value in
         print("!!!! 받았습니다 \(value)")
     }
     */
    func isReportedUser(completed: @escaping (Int) -> Void) {
        let dispatch = DispatchGroup()
        dispatch.enter()
        guard let userUid: String = Auth.auth().currentUser?.uid else {
            return
        }
        var userReportCount: Int = 0
        
        self.db.collection("users")
            .document("\(userUid)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let reportCount = data!["report"] as? Int {
                        print("!!!! 함수 내부 reportCount : \(reportCount)")
                        userReportCount = reportCount
                    }
                } else {
                    print("게시글에서 유저 정보를 불러오는데 오류가 발생했습니다.")
                }
                dispatch.leave()
            }
        
        
        dispatch.notify(queue: .main, execute: {
            print("!!!! final: \(userReportCount)")
            completed(userReportCount)
            
        })
        
        
        
    }

}
