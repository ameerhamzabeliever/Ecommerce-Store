//
//  CountryResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - CountryResponse -

struct CountryResponse: Codable {
    var code: Int?
    var message: String?
    var data: [CountryResponseData]?
    var error: [String]?
}

// MARK: - CountryResponseData

struct CountryResponseData: Codable {
    var id: Int?
    var name: String?
}
