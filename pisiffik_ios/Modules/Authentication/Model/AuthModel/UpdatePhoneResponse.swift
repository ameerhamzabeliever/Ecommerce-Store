//
//  UpdatePhoneResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdatePhoneResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String = ""
    var data: UpdatePhoneResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}


struct UpdatePhoneResponseData: Codable {
    
    var newPhone: String?
    var oldPhone: String?

    enum CodingKeys: String, CodingKey {
        case newPhone = "new_phone"
        case oldPhone = "old_phone"
    }
}
