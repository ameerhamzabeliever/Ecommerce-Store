//
//  StorePurchaseResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct StorePurchaseResponse: Codable {
    var code: Int?
    var message: String?
    var data: StorePurchaseData?
    var error: [String]?
}

struct StorePurchaseData: Codable {
    
    var type: String?
    var orderNo: Int?
    var orderDate: String?
    var storeId: Int?
    var address: String?
    var amount: Int?
    var redeemPoint: Int?
    var items: [StorePurchaseItems]?
    
    enum CodingKeys: String, CodingKey{
        case type, amount, items
        case orderNo = "order_no"
        case storeId = "store_id"
        case address = "store_address"
        case orderDate = "order_date"
        case redeemPoint = "redeem_point"
    }
}

struct StorePurchaseItems: Codable {
    
    var id: Int?
    var name: String?
    var image: String?
    var itemPrice: Int?
    var salePrice: Int?
    var points: Int?
    
    enum CodingKeys: String, CodingKey{
        case id, name, image, points
        case itemPrice = "item_price"
        case salePrice = "sale_price"
    }
}

