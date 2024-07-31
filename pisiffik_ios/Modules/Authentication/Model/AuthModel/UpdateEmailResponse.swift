//
//  UpdateEmailResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdateEmailResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String = ""
    var data: UpdateEmailResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct UpdateEmailResponseData: Codable {
    
    var newEmail: String?
    var oldEmail: String?

    enum CodingKeys: String, CodingKey {
        case newEmail = "new_email"
        case oldEmail = "old_email"
    }
}
