//
//  MyPointsResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct MyPointsResponse: Codable {
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: MyPointsResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct MyPointsResponseData: Codable {
    var currentPage: Int = 1
    var total: Int = 1
    var points: Int = 0
    var list: [MyPoints]?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case total, points, list
    }
}

struct MyPoints: Codable {
    var id: Int?
    var orderNo: Int?
    var points: Int?
    var type: String?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case id, points, type, date
        case orderNo = "order_no"
    }
}
