//
//  UpdatePreferencesResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - UpdatePreferencesResponse
struct UpdatePreferencesResponse: Codable {
    var code: Int?
    var message: String?
    var data: UpdatePreferencesResponseData?
    var error: [String]?
}


// MARK: - UpdatePreferencesResponseData
struct UpdatePreferencesResponseData: Codable {
    
    var concept : UpdatePreferencesData?
    var category : UpdatePreferencesData?
    
}

// MARK: - UpdatePreferencesData
struct UpdatePreferencesData: Codable {
    var attached : [Int]?
}


//MARK: - REQUEST

struct UpdatePreferenceRequest : Codable{
    var category : Set<Int>?
    var concept : Set<Int>?
    enum CodingKeys: String, CodingKey{
        case category, concept
    }
}

//MARK: - REMOVE PREFERENCE REQUEST -

struct RemoveCategoryRequest: Codable{
    
    var categoryID : Int?
    
    enum CodingKeys: String, CodingKey{
        case categoryID = "id"
    }
    
}
