//
//  ManitoChatListViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

import SwiftyJSON

class MainManitoChatViewModel {
    
    private let db = Firestore.firestore()
    var userUID: String = Auth.auth().currentUser?.uid ?? ""
    
    /*
     ChatList
     */
    // 추후에 홍익대학교 이외에 확장할 경우를 고려해서
    var chatListDB: String {
        return "hongik/chatList/\(userUID)"
    }
    let chatListRelay = BehaviorRelay<[userChatList]>(value: [])
    var userData: [String: String] = []
    
    var manitoChatList: [MainListManitoChat] = [
        MainListManitoChat(uid: "M53GwqRWVafgI3eV6rZjyuGKHOM2",
                           type: "M_FS",
                           nickname: "디모다모",
                           date: "오후 04:14",
                           lastChat: "졸업 심사가 얼마 남지 않았다면서요? 힘내세요!"),
        MainListManitoChat(uid: "iFpbybhDWKUCIowQfYBfUhyQxPu2",
                           type: "M_JI",
                           nickname: "테스트봇1",
                           date: "오후 04:28",
                           lastChat: "‘따라서 해당 부분에서는 그룹을 지을 수 없다' 라고하네요ㅠㅜ"),
        MainListManitoChat(uid: "y6BbFMA1tCeE941oeI8yPZWAUxw2",
                           type: "M_PS",
                           nickname: "CAMPUS",
                           date: "오후 02:14",
                           lastChat: "언제쯤 받을 수 있을까요?! 제가 오후에는 조금 어려울 수도 있을 것 같아서요ㅠㅠㅜㅜ...")
        
    ]
    
    init() {
        chatRoomListLoad()
    }
    
    func chatRoomListLoad() {
        db.collection("\(chatListDB)")
            .getDocuments(completion: { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("댓글을 가져오는데 실패했습니다. \(err.localizedDescription)")
                    return
                }
                
                var chatListArr: [userChatList] = []
                
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    var chatData: userChatList = userChatList()
                    
                    if let chatRoomUid: String = data["chat_room_uid"] as? String {
                        chatData.chat_room_uid = chatRoomUid
                    }
                    
                    if let lastMessage: String = data["last_message"] as? String {
                        chatData.last_message = lastMessage
                    }
                    
                    if let targetUserUid: String = data["target_user_uid"] as? String {
                        chatData.target_user_uid = targetUserUid
                    }
                    
                    if let timestamp: Int = data["timestamp"] as? Int {
                        chatData.timestamp = timestamp
                    }
                    
                    if let unreadMessageCount: Int = data["unread_message_count"] as? Int {
                        chatData.unread_message_count = unreadMessageCount
                    }
                    
                    //                    print(chatData)
                    //                    guard let checkedChatData = chatData else { return }
                    chatListArr.append(chatData)
                    
                }
                
                print(chatListArr)
                self?.chatListRelay.accept(chatListArr)
            })
    }
    
    func targetUserLoad(userUid: String) {
        db.collection("users").document("\(userUid)")
            .getDocument { [weak self] (document, err) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    if let nickname: String = data!["nickName"] as? String {
                        
                    }
                    
                    if let dpti: String = data!["dpti"] as? String {
                        
                    }
                    
                } else {
                    print("메인 채팅 리스트에서 유저 정보를 불러오는데 오류가 발생했습니다.")
                }
            }
    }
}
