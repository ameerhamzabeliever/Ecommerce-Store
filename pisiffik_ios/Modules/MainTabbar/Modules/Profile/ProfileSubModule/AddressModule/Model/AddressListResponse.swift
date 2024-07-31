//
//  AddressListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - AddressListResponse -

struct AddressListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: AddressListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - AddressListResponseData -

struct AddressListResponseData: Codable {
    
    var addresses: [AddressList]?
    
    enum CodingKeys: String, CodingKey{
        case addresses
    }
    
}

struct AddressList: Codable {
    
    var id: Int?
    var customerID : String?
    var name : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var additionalInfo : String?
    var instructions : String?
    var isDefault : Bool?
    
    enum CodingKeys: String, CodingKey{
        case id
        case customerID = "customer_id"
        case name
        case address
        case latitude
        case longitude
        case additionalInfo = "additional_info"
        case instructions
        case isDefault = "is_default"
    }
    
}



struct DeleteAddressRequest: Codable{
    var id : Int
}
