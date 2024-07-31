//
//  MyPointsRequest.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct MyPointsRequest: Codable {
    var type: String
    var sort: String
    var limit: Int
}
