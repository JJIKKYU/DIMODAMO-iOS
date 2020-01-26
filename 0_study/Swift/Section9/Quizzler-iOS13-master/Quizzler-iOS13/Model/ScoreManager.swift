//
//  ScoreManager.swift
//  Quizzler-iOS13
//
//  Created by JJIKKYU on 2020/01/08.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct ScoreManager {
    var score: Int
    
    init() {
        self.score = 0
    }
        
    mutating func addScore(_ num: Int) {
        score += num
    }
    
    func getScore() -> Int {
        return score
    }
}
