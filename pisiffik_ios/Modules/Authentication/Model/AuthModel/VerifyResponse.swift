//
//  VerifyResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation


// MARK: - VerifyResponse
struct VerifyResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String = ""
    var data: UserAccessToken?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - UserAccessToken

struct UserAccessToken: Codable {
    
    var accessToken: String?
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "access_token"
    }
    
}
