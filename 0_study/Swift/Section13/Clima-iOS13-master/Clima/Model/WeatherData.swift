//
//  WeatherData.swift
//  Clima
//
//  Created by JJIKKYU on 2020/01/11.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
