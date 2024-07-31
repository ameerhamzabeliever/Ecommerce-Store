//
//  UpdateProfileResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - UpdateProfileResponse -

struct UpdateProfileResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: UpdateProfileResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - UpdateProfileResponseData -

struct UpdateProfileResponseData: Codable {
    
    var user: UserData?
    
    enum CodingKeys: String, CodingKey{
        case user = "customer"
    }
    
}

struct UpdateProfileRequest: Codable{
    var full_name : String
    var dob : String
    var gender_id : Int
    var email : String?
}
