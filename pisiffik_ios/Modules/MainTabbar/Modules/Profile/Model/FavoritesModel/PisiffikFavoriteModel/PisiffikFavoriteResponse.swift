//
//  PisiffikFavoriteResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - PisiffikFavoriteResponse -

struct PisiffikFavoriteResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: PisiffikFavoriteResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - PisiffikFavoriteResponseData -

struct PisiffikFavoriteResponseData: Codable {

    var products: [OfferList]?
    
}


//MARK: - REQUEST -

struct PisiffikFavoriteRequest: Codable{
    
    var conceptID : Int?
    
    enum CodingKeys: String, CodingKey{
        case conceptID = "concept_id"
    }
    
}
