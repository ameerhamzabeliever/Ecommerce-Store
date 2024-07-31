//
//  EventDetailResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - EventDetailResponse -

struct EventDetailResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: EventDetailResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - EventsListResponseData -

struct EventDetailResponseData: Codable {
    
    var stores : [EventDetailStores]?
    
    enum CodingKeys: String, CodingKey{
        case stores
    }
    
}


struct EventDetailStores: Codable {
    
    var id: Int?
    var name : String?
    var address : String?
    var distance : String?
    var concept : String?
    var date : [EventDetailDate] = []
    var latitude : String?
    var longitude : String?
    
    enum CodingKeys: String, CodingKey{
        case id, name, address, distance, concept, date, latitude, longitude
    }
    
}


struct EventDetailDate: Codable {
    var date: String?
    var times: [EventDetailTime] = []
}


struct EventDetailTime: Codable {
    var id : Int?
    var identifier: String?
    var startTime, endTime: String?
    var isSelected : Bool?
    var startTimestamp : String?
    var endTimestamp: String?

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case id, identifier, isSelected
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
    }
}


//MARK: - Event Detail Request -

struct EventDetailRequest: Codable {
    
    var id : Int
    var latitude: String
    var longitude: String

    enum CodingKeys: String, CodingKey {
        case id, latitude, longitude
    }
}
