//
//  TicketReasonResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct TicketReasonResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: TicketReasonResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct TicketReasonResponseData: Codable {
 
    var reasons : [TicketReasons]?

    enum CodingKeys: String, CodingKey {
        case reasons
    }
}

struct TicketReasons: Codable {
 
    var id : Int?
    var name : String?
    var createdAt : String?
    var updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
