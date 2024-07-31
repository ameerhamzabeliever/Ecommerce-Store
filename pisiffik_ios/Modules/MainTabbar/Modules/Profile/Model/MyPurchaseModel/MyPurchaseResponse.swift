//
//  MyPurchaseResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct MyPurchaseResponse: Codable {
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: [MyPurchaseList]?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct MyPurchaseList: Codable {
    
    var id: Int?
    var orderNo: Int?
    var date: String?
    var purchaseType: String?
    var orderType: String?
    var images: [String]?
    
    enum CodingKeys: String, CodingKey{
        case id, date, images
        case orderNo = "order_no"
        case purchaseType = "purchase_type"
        case orderType = "order_type"
    }
}
