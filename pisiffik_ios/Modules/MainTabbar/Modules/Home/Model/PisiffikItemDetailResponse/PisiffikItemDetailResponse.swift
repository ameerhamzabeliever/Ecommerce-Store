//
//  PisiffikItemDetailResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - PisiffikItemDetailResponse

struct PisiffikItemDetailResponse: Codable {
    var code : Int?
    var message : String?
    var data : PisiffikItemDetailResponseData?
    var error : [String]?
}

// MARK: - PisiffikItemDetailResponseData

struct PisiffikItemDetailResponseData: Codable {
    var stores: [PisiffikItemDetailStores]?
}


struct PisiffikItemDetailStores: Codable {
    
    var id: Int?
    var name : String?
    var conceptImage : String?
    var address : String?
    var distance : String?
    var timings : [PisiffikItemDetailStoresTimings]?
    var latitude : String?
    var longitude : String?
    
    enum CodingKeys: String, CodingKey{
        case id = "store_id"
        case name = "store_name"
        case conceptImage = "concept_image"
        case address = "store_address"
        case distance, timings, latitude, longitude
    }
    
}

struct PisiffikItemDetailStoresTimings: Codable {
    
    var day: String?
    var from : String?
    var to : String?
    
    enum CodingKeys: String, CodingKey{
        case day, from, to
    }
    
}
