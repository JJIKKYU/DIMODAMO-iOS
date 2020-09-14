//
//  DptiResult.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

struct DptiResult : Decodable {
    var type : String
    var color : String
    var colorHex : String
    var shape : String
    var desc : String
    var position : String
    var design : [String]
    var designDesc : [String]
    var toolImg : String
    var toolName : String
    var toolDesc : String
    var todo : String
    var title : String
}

extension DptiResult {
    static func initVariables(item : DptiResult) -> DptiResult {
        return DptiResult(type: item.type, color: item.color, colorHex: item.colorHex, shape: item.shape, desc: item.desc, position: item.position, design: item.design, designDesc: item.designDesc, toolImg: item.toolImg, toolName: item.toolName, toolDesc: item.toolDesc, todo: item.todo, title: item.title)
    }
}

