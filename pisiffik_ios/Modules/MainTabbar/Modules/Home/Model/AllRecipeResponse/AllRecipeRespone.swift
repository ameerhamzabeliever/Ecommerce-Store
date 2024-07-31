//
//  AllRecipeRespone.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - AllRecipeRespone

struct AllRecipeRespone: Codable {
    var code : Int?
    var message : String?
    var data : AllRecipeResponeData?
    var error : [String]?
}

// MARK: - AllRecipeResponeData

struct AllRecipeResponeData: Codable {
    
    var recipeCategories: [AllRecipeCategories]?
    
    enum CodingKeys: String, CodingKey {
        case recipeCategories = "categoriezed_recipes"
    }
    
}


// MARK: - RecipeDetailData

struct AllRecipeCategories: Codable {
    
    var recipeType: String?
    var recipeTypeID : Int?
    var recipes: [RecipeDetailAboutData]?

    enum CodingKeys: String, CodingKey {
        case recipeType = "recipe_type"
        case recipeTypeID = "recipe_type_id"
        case recipes
    }
}



struct AllRecipeCategoriesSearchRequest: Codable{
    
    let keyword : String?
    let searchIn : String?
    
    enum CodingKeys : String, CodingKey{
        case keyword, searchIn
    }
    
}
