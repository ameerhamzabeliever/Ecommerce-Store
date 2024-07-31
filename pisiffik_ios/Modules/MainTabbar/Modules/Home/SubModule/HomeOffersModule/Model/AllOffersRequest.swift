//
//  AllOffersRequest.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct AllOffersRequest: Codable{
    var conceptID: Int
    var type: String
    var bool: Bool
    
    enum CodingKeys: String, CodingKey{
        case type, bool
        case conceptID = "concept_id"
    }
}
