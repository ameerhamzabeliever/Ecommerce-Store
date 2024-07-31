//
//  AddToFavoriteResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 18/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - RecipeDetailResponse

struct AddToFavoriteResponse: Codable {
    var code : Int?
    var message : String?
    var data : AddToFavoriteResponseData?
    var error : [String]?
}

// MARK: - RecipeDetailResponseData

struct AddToFavoriteResponseData: Codable {
    
    var isFavorite: Int?
    
    enum CodingKeys: String, CodingKey{
        case isFavorite = "is_favorite"
    }
    
}

struct AddRecipeToFavoriteRequest: Codable{
    
    var recipeID : Int?
    
    enum CodingKeys: String, CodingKey{
        case recipeID = "recipe_id"
    }
    
}

struct AddFoodItemToFavoriteRequest: Codable{
    
    var productID : Int?
    var offerItemID: Int?
    
    enum CodingKeys: String, CodingKey{
        case productID = "product_id"
        case offerItemID = "offer_item_id"
    }
    
}

struct AddProductToFavoriteRequest: Codable{
    
    var productID : Int?
    
    enum CodingKeys: String, CodingKey{
        case productID = "product_id"
    }
    
}
