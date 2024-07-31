//
//  ScanProductResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - ScanProductResponse -

struct ScanProductResponse: Codable {
    var code: Int?
    var message: String?
    var data: ScanProductResponseData?
    var error: [String]?
}


// MARK: - ScanProductResponseData -

struct ScanProductResponseData: Codable {
    var product : ScanProductInfo?
}

struct ScanProductInfo : Codable{
    
    var id : Int?
    var name: String?
    var isDiscountEnabled : Bool?
    var salePrice : Double?
    var afterDiscountPrice : Double?
    var points : Int?
    var expiresIn : Int?
    var currency : String?
    var isFavorite : Int?
    var description : String?
    var images : [String]?
    
    enum CodingKeys: String, CodingKey{
        case id, name
        case isDiscountEnabled = "is_discount_enabled"
        case salePrice = "sale_price"
        case afterDiscountPrice = "after_discount_price"
        case points
        case expiresIn = "expires_in"
        case currency
        case isFavorite = "is_favorite"
        case description, images
    }
    
    
}


//MARK: - SCAN PRODUCT REQUEST -

struct ScanProductRequest: Codable{
    var barcode : Int
    enum CodingKeys: String, CodingKey{
        case barcode
    }
}
