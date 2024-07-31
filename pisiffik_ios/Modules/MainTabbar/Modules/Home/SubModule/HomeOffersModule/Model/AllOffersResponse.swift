//
//  AllOffersResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct AllOffersResponse: Codable {
    var code: Int?
    var message: String?
    var data: AllOffersResponseData?
    var error: [String]?
}

struct AllOffersResponseData: Codable {
    var media_url: String?
    var concepts: [AllOffersConcepts]?
    var offer: [OfferList]?
}


struct AllOffersConcepts: Codable {
    var id : Int?
    var name: String?
    var image: String?
    var bannerImage: String?
    var isPrefered : Int?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case bannerImage = "banner_image"
        case isPrefered = "is_prefered"
    }
}
