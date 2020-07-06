//
//  ResponseWithToken.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 06.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

struct ResponseWithToken: Codable {
    var token_type: String
    var access_token: String
    var expires_in: String
    var refresh_token: String

    
}
