//
//  HomeResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - HomeResponse
struct HomeResponse: Codable {
    var code: Int?
    var message: String?
    var data: HomeResponseData?
    var error: [String]?
}

// MARK: - HomeResponseData
struct HomeResponseData: Codable {
    
    var points: Int?
    var shoppingListCount : Int?
    var notificationCount : Int?
    var totalCampaingCount : Int?
    var totalCurrentOffersCount : Int?
    var campaigns: [HomeCampaignData]?
    var recipies: [HomeRecipiesData]?
    var currentOffers : [OfferList]?
    
    enum CodingKeys: String, CodingKey {
        case points, shoppingListCount, campaigns, recipies
        case notificationCount = "notification_count"
        case currentOffers = "current_offers"
        case totalCampaingCount = "total_campaign_count"
        case totalCurrentOffersCount = "total_current_offer_count"
    }
    
}

//MARK: - OfferList -

struct OfferList: Codable {
    
    var id : Int?
    var offerItemId : Int?
    var name : String?
    var isDiscountEnabled : Bool?
    var salePrice : Double?
    var afterDiscountPrice : Double?
    var points : Int?
    var expiresIn : Int?
    var currency : String?
    var description : String?
    var images : [String]?
    var isFavorite : Int?
    var isMember : Int?
    var isFood : Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case offerItemId = "offer_item_id"
        case name
        case isDiscountEnabled = "is_discount_enabled"
        case salePrice = "sale_price"
        case afterDiscountPrice = "after_discount_price"
        case points
        case expiresIn = "expires_in"
        case currency, description, images
        case isFavorite = "is_favorite"
        case isMember = "is_member"
        case isFood = "is_food"
    }
    
}


// MARK: - Campaign
struct HomeCampaignData: Codable {
    var id: Int?
    var banner: String?
}


// MARK: - Points
struct HomePointsData: Codable {
    var loyaltyPoinst, discountInCurrency: Int?
    var currency: String?

    enum CodingKeys: String, CodingKey {
        case loyaltyPoinst = "loyalty_poinst"
        case discountInCurrency = "discount_in_currency"
        case currency
    }
}


// MARK: - Recipies
struct HomeRecipiesData: Codable {
    var id: Int?
    var image, name, chef: String?
    var servedPersons: Int?
    var preparationTime: String?
    var is_favorite : Int?
    var recipe_type : String?

    enum CodingKeys: String, CodingKey {
        case id, image, name, chef, is_favorite, recipe_type
        case servedPersons = "served_persons"
        case preparationTime = "preparation_time"
    }
}
