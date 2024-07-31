//
//  LoginValidationRequest.swift
//  pisiffik-ios
//
//  Created by Haider Ali on 23/05/2022.
//  Copyright © 2022 softwarealliance.dk. All rights reserved.
//

import Foundation

struct LoginValidationRequest: Codable {
    var phone: String
    var email: String
    var password: String
    var fcm_token : String
}


struct LoginRequest: Codable {
    var phone: String?
    var email: String?
    var password: String
    var fcm_token : String
}

