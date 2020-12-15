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
    let loadingRelay = BehaviorRelay<Bool>(value: false)
    let currentStateRelay = BehaviorRelay<BlockProcessState>(value: .none)
    
    init() {
        self.getBlockedUserList()
    }
    
    func getBlockedUserList() {
        guard let userUID = self.myUID else {
            return
        }
        self.loadingRelay.accept(false)
        self.blockedUserMapRelay.accept([])
        
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
                    }
                    self?.blockedUserMapRelay.accept(newBlockUserList)
                    self?.loadingRelay.accept(true)
                    
                } else {
                    print("프로필에서 유저 데이터를 초기화하지 못했습니다.")
                }

            }
    }
    
    func cancleBlockUser(userUID: String) {
        guard let myUserUID = self.myUID else {
            return
        }
        
        // 신고할 때 신고 리스트에 추가
        db.collection("users").document("\(myUserUID)")
            .updateData(
                ["block_user_list.\(userUID)" : FieldValue.delete()]
            )
        
        // 블럭 스태틱 변수 초기화 및 다시 입력
        let blockUserManager = BlockUserManager()
        blockUserManager.blockUserDataReset()
        blockUserManager.blockUserCheck { value in
            print("차단 목록을 최신화합니다. \(value)")
            self.currentStateRelay.accept(.complete)
        }
    }
}

// MARK: - Block Model

class BlockedUserList {
    var uid: String?
    var nickname: String?
    var type: String?
}

enum BlockProcessState {
    case none
    case complete
    case fail
}
