//
//  CityResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - CityResponse

struct CityResponse: Codable {
    var code: Int?
    var message: String?
    var data: [CityResponseData]?
    var error: [String]?
}

// MARK: - CityResponseData

struct CityResponseData: Codable {
    var id: Int?
    var name: String?
}

struct CityRequest: Codable{
    let state_id : Int
}
