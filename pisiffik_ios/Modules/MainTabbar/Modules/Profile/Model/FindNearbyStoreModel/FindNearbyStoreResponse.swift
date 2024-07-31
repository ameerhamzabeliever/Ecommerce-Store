//
//  FindNearbyStoreResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - FindNearbyStoreResponse -

struct FindNearbyStoreResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: FindNearbyStoreResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - FindNearbyStoreResponseData -

struct FindNearbyStoreResponseData: Codable {

    var concepts : [FindNearbyStoreConcepts]?
    var stores: [PisiffikItemDetailStores]?
    
}

struct FindNearbyStoreConcepts: Codable {
    
    var id : Int?
    var name: String?
    var image: String?
    var isPrefered : Int?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case isPrefered = "is_prefered"
    }
}


//MARK: - FIND STORE REQUEST -

struct FindNearbyStoreRequest: Codable {
    
    var conceptID : Int
    var latitude: String
    var longitude: String

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case conceptID = "concept_id"
    }
}
