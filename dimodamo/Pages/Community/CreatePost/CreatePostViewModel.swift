//
//  CreatePostViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/10/25.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

import Firebase

class CreatePostViewModel {
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    // 제목
    let titleRelay = BehaviorRelay<String>(value: "")
    var titleLimit: String { return "\(titleRelay.value.count)/20" }
    
    // 태그
    let tagsRelay = BehaviorRelay<String>(value: "")
    var tags: [String] = ["", "", ""]
    var tagsLimit: String {
        // # 태그가 있는 단어들을 찾아서 태그 때고  다 소문자로 해주기
        let sliceArray = tagsRelay.value.getArrayAfterRegex(regex:"#[^ ]+").map { (slice) in
            slice.replacingOccurrences(of: "#", with: "").lowercased()
        }
        
        return "\(sliceArray.count)/3"
    }
    var tagsLimitCount: Int {
        let sliceArray = tagsRelay.value.getArrayAfterRegex(regex:"#[^ ]+").map { (slice) in
            slice.replacingOccurrences(of: "#", with: "").lowercased()
        }
        
        return sliceArray.count
    }
    
    // 내용
    let descriptionRelay = BehaviorRelay<String>(value: "")
    var descriptionLimit: String {
        return "\(descriptionRelay.value.count)/1000"
    }
    
    init() {
        
    }
    
    func sendPost() {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        
        // 유저 디폹트에서 닉네임을 불러옴
        let userDefaults = UserDefaults.standard
        let userNickname: String = userDefaults.string(forKey: "nickname") ?? "익명"
        let userDpti: String = userDefaults.string(forKey: "dpti") ?? "TI"
        
        // DocumentID를 미리 불러오기 위해
        
        let document = db.collection("hongik/information/posts").document()
        let id: String = document.documentID
        
        
        let board: Board = Board(boardId: id,
                                 boardTitle: titleRelay.value,
                                 bundleId: unixTimestamp,
                                 category: "magazine",
                                 commentCount: 0,
                                 createdAt: "\(strDate)",
                                 description: "\(descriptionRelay.value)",
                                 images: [],
                                 links: [],
                                 nickname: userNickname,
                                 scrapCount: 0,
                                 tags: tags,
                                 userDpti: userDpti,
                                 userId: Auth.auth().currentUser?.uid,
                                 videos: [])
        
        _ = document.setData(board.dictionary) { err in
            if let err = err {
                print("게시글을 작성하는데 오류가 발생했습니다. \(err.localizedDescription)")
            } else {
                print("정상적으로 글이 작성되었습니다. \(id)")
            }
        }
    }
}



// MARK: - 정규식 익스텐션
// https://eunjin3786.tistory.com/12

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
