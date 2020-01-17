//
//  RefreshTokenData.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/16/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import Foundation

struct RefreshTokenData: Decodable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
}
