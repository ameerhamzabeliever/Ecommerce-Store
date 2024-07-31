//
//  CampaignDetailResponse.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct CampaignDetailResponse: Codable {
    var code: Int?
    var message: String?
    var data: CampaignDetailResponseData?
    var error: [String]?
}

struct CampaignDetailResponseData: Codable {
    var media_url: String?
    var campaign: CampaignDetailCampaignsData?
    var item: [OfferList]?
    var item_count: Int?
}

struct CampaignDetailCampaignsData: Codable {
    var id: Int?
    var concept_id: Int?
    var name: String?
    var banner: String?
    var is_active: Bool?
}
