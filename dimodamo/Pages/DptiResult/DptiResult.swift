//
//  DptiResult.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/14.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import Foundation

struct DptiResult : Decodable {
    let type : String
    let color : String
    let colorHex : String
    let shape : String
    let desc : String
    let position : String
    let design : [String]
    let designDesc : [String]
    let toolImg : String
    let toolName : String
    let toolDesc : String
    let todo : String
}
