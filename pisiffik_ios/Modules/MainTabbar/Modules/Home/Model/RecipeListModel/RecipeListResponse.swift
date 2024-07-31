//
//  RecipeListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - RecipeListResponse

struct RecipeListResponse: Codable {
    var code : Int?
    var message : String?
    var data : RecipeListResponseData?
    var error : [String]?
}

// MARK: - RecipeListResponseData

struct RecipeListResponseData: Codable {
    
    var currentPage : Int?
    var lastPage : Int?
    var recipes : [RecipeDetailAboutData]?
    
    enum CodingKeys : String, CodingKey{
        case recipes
        case lastPage = "last_page"
        case currentPage = "current_page"
    }
    
}

struct RecipeListRequest: Codable{
    
    let recipeTypeID : Int?
    
    enum CodingKeys : String, CodingKey{
        case recipeTypeID = "recipe_type_id"
    }
    
}

struct RecipeListSearchRequest: Codable{
    
    let keyword : String?
    let searchIn : String?
    let recipeTypeID : Int?
    
    enum CodingKeys : String, CodingKey{
        case keyword, searchIn
        case recipeTypeID = "recipe_type_id"
    }
    
}
