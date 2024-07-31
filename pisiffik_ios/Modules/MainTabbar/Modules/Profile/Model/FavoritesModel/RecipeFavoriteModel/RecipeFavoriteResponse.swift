//
//  RecipeFavoriteResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - RecipeFavoriteResponse -

struct RecipeFavoriteResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: RecipeFavoriteResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - RecipeFavoriteResponseData -

struct RecipeFavoriteResponseData: Codable {
    
    var currentPage : Int?
    var lastPage : Int?
    var recipes: [HomeRecipiesData]?
    
    enum CodingKeys: String, CodingKey{
        case recipes
        case lastPage = "last_page"
        case currentPage = "current_page"
    }
    
}
