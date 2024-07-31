//
//  EventLocalData.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct EventLocalData: Codable{
    var events : [EventData]?
    enum CodingKeys: String, CodingKey{
        case events
    }
}

struct EventData: Codable{
    var eventID : Int?
    var timeData : [EventTimeData] = []
    enum CodingKeys: String, CodingKey{
        case eventID = "event_id"
        case timeData = "time_data"
    }
}

struct EventTimeData: Codable{
    var id : Int?
    var identifier : String?
    enum CodingKeys: String, CodingKey{
        case id, identifier
    }
}

