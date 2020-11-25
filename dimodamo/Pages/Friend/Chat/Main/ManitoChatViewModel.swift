//
//  ManitoChatViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class ManitoChatViewModel {
    
    private let db = Firestore.firestore()
    var userUID: String = Auth.auth().currentUser?.uid ?? ""
    
    let disposebag = DisposeBag()
    
    /*
     상대방 유저 타입 -> 타입에 따라서 컬러 변경하기 위해서
     */
    var yourType: String?
    var yourNickname: String?
    // 상대방 UID
    var yourUID: String?
    
    /*
     ChatList
     */
    // 추후에 홍익대학교 이외에 확장할 경우를 고려해서
    var chatUid = BehaviorRelay<String>(value: "")
    var chatDB: String {
        return "hongik/messages/\(chatUid.value)"
    }
    let messageArrRelay = BehaviorRelay<[Message]>(value: [])
    var userDataArr = [String: String]()
    let messageLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        chatUid
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] chatuid in
                if chatuid.count > 0 {
                    self?.chatMessagesLoad()
                    print("메세지를 로드합니다.")
                }
            })
            .disposed(by: disposebag)
            
    }
    
    func chatMessagesLoad() {
        db.collection("\(chatDB)")
            .order(by: "timestamp", descending: false)
            .getDocuments(completion: { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("댓글을 가져오는데 실패했습니다. \(err.localizedDescription)")
                    return
                }
                
                var messageListArr: [Message] = []
                
                for document in querySnapshot!.documents {
                    
                    print("###### \(document.data())")
                    let data = document.data()
                    var messageData: Message = Message()
                    
                    if let isRead: Bool = data["is_read"] as? Bool {
                        messageData.is_read = isRead
                    }
                    
                    if let message = data["message"] as? String {
                        messageData.message = message
                    }
                    
                    if let photoURL = data["photo"] as? String {
                        messageData.photo = photoURL
                    }
                    
                    if let timestamp = data["timestamp"] as? Int {
                        messageData.timestamp = timestamp
                    }
                    
                    if let uid = data["uid"] as? String {
                        messageData.uid = uid
                    }
                    if let userUid = data["user_uid"] as? String {
                        messageData.user_uid = userUid
                    }
                    
                    
                    //                    print(chatData)
                    //                    guard let checkedChatData = chatData else { return }
                    messageListArr.append(messageData)
                    
                }
                
                print(messageListArr)
                self?.messageArrRelay.accept(messageListArr)
                self?.messageLoadingRelay.accept(true)
            })
    }
    
    func getUserNickname(userUid: String) -> String {
        
        let nickname: String = self.userDataArr["\(userUid)_nickname"] ?? ""
        print("\(nickname) 닉네임 로드합니다")
        
        return nickname
    }
    
    func getUserDpti(userUid: String) -> String {
        
        let dpti: String = self.userDataArr["\(userUid)_dpti"] ?? ""
        print("\(dpti) 타입 로드합니다")
        
        return dpti
    }
}
