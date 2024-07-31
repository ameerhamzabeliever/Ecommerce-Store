//
//  OfferEventsBaseResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - OfferEventsBaseResponse -

struct OfferEventsBaseResponse: Codable {
    var code : Int?
    var message : String?
    var data : OfferEventsResponseData?
    var error : [String]?
}


// MARK: - ShoppingListResponse -

struct OfferEventsResponseData: Codable {
    
    var offers: OfferEventsData?
    
    enum CodingKeys: String, CodingKey {
        case offers
    }
    
}

struct OfferEventsData: Codable {
    
    var events: [EventsList]?

    enum CodingKeys: String, CodingKey {
        case events
    }
    
}

