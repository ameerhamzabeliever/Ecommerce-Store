//
//  StateResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - StateResponse

struct StateResponse: Codable {
    var code: Int?
    var message: String?
    var data: [StateResponseData]?
    var error: [String]?
}

// MARK: - StateResponseData

struct StateResponseData: Codable {
    var id: Int?
    var name: String?
}


struct StateRequest: Codable{
    let country_id : Int
}
