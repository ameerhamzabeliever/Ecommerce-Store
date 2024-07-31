//
//  TicketDetailResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - TicketListResponse -

struct TicketDetailResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: TicketDetailResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - TicketListResponseData -

struct TicketDetailResponseData: Codable {
    
    var messasgesList: [TicketDetailMessages]?
    
    enum CodingKeys: String, CodingKey{
        case messasgesList = "messages"
    }
    
}

struct TicketDetailMessages: Codable {
    
    var id: Int?
    var ticketID : Int?
    var message : String?
    var agent : TicketDetailAgent?
    var customer : TicketDetailAgent?
    var attachment : [TicketAttacment]?
    var date : String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case ticketID = "ticket_id"
        case message
        case agent
        case customer
        case attachment
        case date = "created_at"
    }
    
}

struct TicketDetailAgent: Codable{
    
    var id: String
    var fullName: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case fullName = "name"
    }
    
}

struct TicketAttacment: Codable{
    var id : Int?
    var messageID : Int?
    var attachmentName : String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case messageID = "message_id"
        case attachmentName = "attachment_name"
    }
    
}


struct TicketDetailRequest: Codable{
    
    var ticketID : Int
    
    enum CodingKeys: String, CodingKey{
        case ticketID = "ticket_id"
    }
    
}
