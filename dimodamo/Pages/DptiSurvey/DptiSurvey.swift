//
//  DptiSurvey.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/16.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

struct DptiSurvey {
    var number : Int = 1
    var question : String = ""
}

struct UserSurveyAnswer {
    var answers : [String : Int] = [
        "1" : 0,
    ]
}

struct FeedbackCardTitle {
    var title : [String] = [
        "좋아! 아주 멋져~",
        "매우 잘하고 있어!",
        "좋아 최고야~",
        "잠시만 기다려줘!"
    ]
}
