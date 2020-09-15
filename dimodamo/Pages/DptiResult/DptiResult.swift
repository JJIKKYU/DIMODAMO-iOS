//
//  DptiResult.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

struct DptiResult : Decodable {
    var type : String = ""
    var color : String = ""
    var colorHex : String = ""
    var shape : String = ""
    var desc : String = ""
    var position : String = ""
    var design : [String] = []
    var designDesc : [String] = []
    var toolImg : String = ""
    var toolName : String = ""
    var toolDesc : String = ""
    var todo : String =  ""
    var title : String = ""
}

extension DptiResult {
    static func initVariables(item : [String : Any]) -> DptiResult {
        return DptiResult(type: item["type"] as! String,
                          color: item["color"] as! String,
                          colorHex: item["colorHex"] as! String,
                          shape: item["shape"] as! String,
                          desc: item["desc"] as! String,
                          position: item["position"] as! String,
                          design: item["design"] as! [String],
                          designDesc: item["designDesc"] as! [String],
                          toolImg: item["toolImg"] as! String,
                          toolName: item["toolName"] as! String,
                          toolDesc: item["toolDesc"]  as! String,
                          todo: item["todo"] as! String,
                          title: item["title"]  as! String
        )
    }
}

