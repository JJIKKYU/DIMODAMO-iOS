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
    
    // 제목
    let titleRelay = BehaviorRelay<String>(value: "")
    var titleLimit: String { return "\(titleRelay.value.count)/20" }
    
    // 태그
    let tagsRelay = BehaviorRelay<String>(value: "")
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
