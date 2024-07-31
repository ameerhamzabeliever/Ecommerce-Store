//
//  RecipeDetailResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - RecipeDetailResponse

struct RecipeDetailResponse: Codable {
    var code : Int?
    var message : String?
    var data : RecipeDetailResponseData?
    var error : [String]?
}

// MARK: - RecipeDetailResponseData

struct RecipeDetailResponseData: Codable {
    var recipe: RecipeDetailData?
}


// MARK: - RecipeDetailData

struct RecipeDetailData: Codable {
    
    var recipeDetail: RecipeDetailAboutData?
    var ingredients: [RecipeDetailIngredient]?
    var instructions: String?
    var tips : String?

    enum CodingKeys: String, CodingKey {
        case recipeDetail, ingredients, instructions, tips
    }
}

// MARK: - RecipeDetailIngredient

struct RecipeDetailIngredient: Codable {
    var id: Int?
    var name: String?
    var recipeQuantity, uomQuantity: Int?
    var uom: String?
    var recipeUom : String?

    enum CodingKeys: String, CodingKey {
        case id = "variant_id"
        case name
        case recipeQuantity = "recipe_quantity"
        case uomQuantity = "uom_quantity"
        case uom
        case recipeUom = "recipe_uom"
    }
}


// MARK: - RecipeDetailAboutData

struct RecipeDetailAboutData: Codable {
    var id: Int?
    var image, name, chef: String?
    var servedPersons: Int?
    var preparationTime: String?
    var recipeType : String?
    var isFavorite : Int?

    enum CodingKeys: String, CodingKey {
        case id, image, name, chef
        case servedPersons = "served_persons"
        case preparationTime = "preparation_time"
        case recipeType = "recipe_type"
        case isFavorite = "is_favorite"
    }
}



struct RecipeItems{
    var id: Int
    var name: String
    var recipeQuantity, uomQuantity: Int
    var uom: String
    var recipeUom : String
    var isSelected: Bool
}
