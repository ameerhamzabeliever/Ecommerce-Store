//
//  CustomerServiceResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct CustomerServiceResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: CustomerServiceResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct CustomerServiceResponseData: Codable {
 
    var customerService : CustomerServiceDetail?

    enum CodingKeys: String, CodingKey {
        case customerService = "customer_service"
    }
}

struct CustomerServiceDetail: Codable {
 
    var number : String?
    var timings : [PisiffikItemDetailStoresTimings]?

}
