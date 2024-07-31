//
//  AuthResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - AuthResponse
struct AuthResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: AuthResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - AuthResponseData

struct AuthResponseData: Codable {
    
    var access_token: String?
    var media_url: String?
    var user: UserData?
    
    enum CodingKeys: String, CodingKey{
        case user = "customer"
        case media_url
        case access_token
    }
    
}
