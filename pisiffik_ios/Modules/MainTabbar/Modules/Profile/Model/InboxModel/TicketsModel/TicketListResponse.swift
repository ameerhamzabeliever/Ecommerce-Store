//
//  TicketListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - TicketListResponse -

struct TicketListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: TicketListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - TicketListResponseData -

struct TicketListResponseData: Codable {
    
    var tickets: [TicketList]?
    
    enum CodingKeys: String, CodingKey{
        case tickets
    }
    
}

struct TicketList: Codable {
    
    var id: Int?
    var subject : String?
    var status : Int?
    var createdAt : String?
    var updatedAt : String?
    var unreadMsgCount : Int?
    var reason : String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case subject
        case status
        case reason
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case unreadMsgCount = "unread_msg_count"
    }
    
}
