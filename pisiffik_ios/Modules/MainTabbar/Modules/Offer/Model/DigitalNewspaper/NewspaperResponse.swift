//
//  NewspaperResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/11/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - NewspaperResponse -

struct NewspaperResponse: Codable {
    var code : Int?
    var message : String?
    var data : NewspaperResponseData?
    var error : [String]?
}


// MARK: - NewspaperResponseData -

struct NewspaperResponseData: Codable {
    
    var newspapers: [DigitalNewspaper]?
    
    enum CodingKeys: String, CodingKey {
        case newspapers = "OfferNewspaperListing"
    }
    
}

struct DigitalNewspaper: Codable {
    
    var id: Int?
    var newspaperID : Int?
    var concept : String?
    var webLink : String?
    var coverImage : String?
    var startDate : String?
    var endDate : String?

    enum CodingKeys: String, CodingKey {
        case id, concept
        case newspaperID = "newspaper_id"
        case webLink = "web_link"
        case coverImage = "cover_image"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
}
