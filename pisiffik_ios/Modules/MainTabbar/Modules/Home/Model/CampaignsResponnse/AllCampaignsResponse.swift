//
//  AllCampaignsResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct AllCampaignsResponse: Codable {
    var code: Int?
    var message: String?
    var data: AllCampaignsResponseData?
    var error: [String]?
}

struct AllCampaignsResponseData: Codable {
    var media_url: String?
    var campaign: [HomeCampaignData]?
}
