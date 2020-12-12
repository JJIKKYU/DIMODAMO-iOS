//
//  BlockUser.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/12.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

class BlockUserManager {
    
    private let db = Firestore.firestore()
    
    
    /*
     user의 report 횟수를 가져오는 비동기 함수
     
     // 사용법
     let user = UserData()
     user.testReportUser { value in
         print("!!!! 받았습니다 \(value)")
     }
     */
    func blockUserCheck(completed: @escaping ([String:Bool]) -> Void) {
        let dispatch = DispatchGroup()
        dispatch.enter()
        guard let userUid: String = Auth.auth().currentUser?.uid else {
            return
        }
        var blockedUserMap: [String:Bool] = [:]
        
        self.db.collection("users")
            .document("\(userUid)")
            .getDocument { (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let blockedUserData: [String:Bool] = data!["block_user_list"] as? [String:Bool] {
                        print("##### 차단한 유저가 있습니다 \(blockedUserData)")
                        blockedUserMap = blockedUserData
                    }
                    
                    
                } else {
                    print("차단 유저 정보를 불러오는데 오류가 발생했습니다.")
                }
                dispatch.leave()
            }
        
        
        dispatch.notify(queue: .main, execute: {
            print("!!!! 차단 유저 정보 Return: \(blockedUserMap)")
            completed(blockedUserMap)
        })
    }
    
    
}