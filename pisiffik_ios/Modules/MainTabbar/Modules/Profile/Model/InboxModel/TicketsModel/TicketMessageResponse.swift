//
//  TicketMessageResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 17/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct TicketMessageResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: TicketMessageResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}


struct TicketMessageResponseData: Codable {
    
    var message: TicketDetailMessages?
    
    enum CodingKeys: String, CodingKey{
        case message
    }
    
}


struct TicketMessageRequest: Codable{
    
    var ticketID : String
    var message : String
    
    enum CodingKeys: String, CodingKey{
        case message
        case ticketID = "ticket_id"
    }
    
}
