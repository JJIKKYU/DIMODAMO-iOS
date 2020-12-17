//
//  CreateTagsViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/12/15.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

class CreateTagsViewModel {
        
    // 태그를 입력하는 텍스트 필드
    let tagTextRelay = BehaviorRelay<String>(value: "")
    
    // 입력한 태그 목록
    let inputTagsRelay = BehaviorRelay<[String]>(value: [])
    var inputTagsCount: Int {
        return inputTagsRelay.value.count
    }

    
    init() {
        
    }
}
