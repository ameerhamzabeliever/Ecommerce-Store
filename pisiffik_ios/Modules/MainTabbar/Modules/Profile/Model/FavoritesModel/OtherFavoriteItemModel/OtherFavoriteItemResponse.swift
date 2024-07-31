//
//  OtherFavoriteItemResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - OtherFavoriteItemResponse -

struct OtherFavoriteItemResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: OtherFavoriteItemResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - OtherFavoriteItemResponseData -

struct OtherFavoriteItemResponseData: Codable {

    var products: [OfferList]?
    
}
