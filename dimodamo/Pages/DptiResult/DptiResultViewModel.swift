//
//  DptiResultViewModel.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DptiResultViewModel {
    lazy var resultObservable = BehaviorRelay<[DptiResult]>(value: [])
    
    init() {
        print(APIService.fetchAllResults())
    }
}

