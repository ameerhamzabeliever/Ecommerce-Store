//
//  AddTicketResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddTicketResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: AddTicketResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct AddTicketResponseData: Codable {
 
    var ticket : AddTicketData?

    enum CodingKeys: String, CodingKey {
        case ticket
    }
}

struct AddTicketData: Codable {
 
    var ticketDetail : TicketList?
    var message : TicketDetailMessages?

    enum CodingKeys: String, CodingKey {
        case ticketDetail, message
    }
}

struct AddTicketRequest: Codable{
    var reason : String
    var subject : String
    var message : String
}
