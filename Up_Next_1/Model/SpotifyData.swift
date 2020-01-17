//
//  SpotifyData.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/16/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import Foundation

struct SpotifyData: Decodable {
    let playlist_uri: String
    let events_found: String
//    let main: Main
//    let weather: [Weather]
//    let sys: Sys
}

//struct Main: Decodable {
//    let temp: Double
//}
//
//struct Weather: Decodable {
//    let description: String
//}
//
//struct Sys: Decodable {
//    let sunrise: Int
//}
