//
//  GenerateBarcodeResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - GenerateBarcodeResponse -

struct GenerateBarcodeResponse: Codable {
    var code: Int?
    var message: String?
    var data: GenerateBarcodeResponseData?
    var error: [String]?
}


// MARK: - GenerateBarcodeResponseData -

struct GenerateBarcodeResponseData: Codable {
    var image : String?
    var cardNumber : String?
    var loyaltyId : String?
    enum CodingKeys: String, CodingKey{
        case image
        case cardNumber = "card_number"
        case loyaltyId = "loyalty_id"
    }
}
