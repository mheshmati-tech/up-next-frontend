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
    let successfully_generated: String
    let playlist_url: String
    let wait_time: String
    let rate_limited: String
}
