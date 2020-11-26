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
        "좋아! 잘하고 있어!",
        "호~ 그렇단 말이지!",
        "와! 아주 멋진걸?",
        "결과를 보러가자!"
    ]
}
