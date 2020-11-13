//
//  ManitoChatListViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/11/13.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

class MainManitoChatViewModel {
    
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
        
    }
}
