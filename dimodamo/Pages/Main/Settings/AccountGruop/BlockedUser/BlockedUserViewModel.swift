//
//  BlockedUserViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import Firebase

import RxSwift
import RxCocoa

class BlockedUserViewModel {
    
    private let db = Firestore.firestore()
    
    var myUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    let blockedUserMapRelay = BehaviorRelay<[BlockedUserList]>(value: [])
    
    init() {
        self.getBlockedUserList()
    }
    
    func getBlockedUserList() {
        guard let userUID = self.myUID else {
            return
        }
        
        db.collection("users")
            .document("\(userUID)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    var newBlockUserList: [BlockedUserList] = []
                        
                    if let blockList = data!["block_user_list"] as? [String: [String: String]] {
                        
                        for block in blockList {
                            let newBlockUser: BlockedUserList = BlockedUserList()
                            
                            let UID: String = block.key
                            newBlockUser.uid = UID
                            
                            if let nickname: String = block.value["nickname"] {
                                newBlockUser.nickname = nickname
                            }
                            if let type: String = block.value["type"] {
                                newBlockUser.type = type
                            }
                            
                            newBlockUserList.append(newBlockUser)
                        }
                        
                        self?.blockedUserMapRelay.accept(newBlockUserList)
                    }
                    
                } else {
                    print("프로필에서 유저 데이터를 초기화하지 못했습니다.")
                }
                
                
            }
    }
}

// MARK: - Block Model

class BlockedUserList {
    var uid: String?
    var nickname: String?
    var type: String?
}
