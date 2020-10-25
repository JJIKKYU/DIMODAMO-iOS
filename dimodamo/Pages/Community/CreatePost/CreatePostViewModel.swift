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
    
    // 내용
    let descriptionRelay = BehaviorRelay<String>(value: "")
    
    init() {
        
    }
}
