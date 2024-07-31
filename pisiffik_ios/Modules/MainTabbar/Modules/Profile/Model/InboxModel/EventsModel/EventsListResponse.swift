//
//  EventsListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - EventsListResponse -

struct EventsListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: EventsListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - EventsListResponseData -

struct EventsListResponseData: Codable {
    
    var currentPage : Int?
    var lastPage : Int?
    var events: [EventsList]?
    
    enum CodingKeys: String, CodingKey{
        case events
        case currentPage = "current_page"
        case lastPage = "last_page"
    }
    
}

struct EventsList: Codable {
    
    var id: Int?
    var name : String?
    var description : String?
    var image : String?
    var date : String?
    var isRead : Int?
    
    enum CodingKeys: String, CodingKey{
        case id, name, image, date, description
        case isRead = "is_read"
    }
    
}
