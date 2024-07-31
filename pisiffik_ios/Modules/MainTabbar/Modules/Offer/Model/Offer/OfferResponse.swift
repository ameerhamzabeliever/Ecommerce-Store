//
//  OfferResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 18/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct OfferResponse: Codable {
    var code : Int?
    var message : String?
    var data : OfferResponseData?
    var error : [String]?
}

struct OfferResponseData: Codable {
    var media_url : String?
    var concepts : [AllOffersConcepts]?
    var personal : [OfferList]?
    var local : [OfferList]?
    var membership : [OfferList]?
}
