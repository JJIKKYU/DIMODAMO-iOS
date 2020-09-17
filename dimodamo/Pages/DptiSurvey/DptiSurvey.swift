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
