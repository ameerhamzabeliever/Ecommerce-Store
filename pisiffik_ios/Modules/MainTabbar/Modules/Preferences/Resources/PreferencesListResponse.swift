//
//  PreferencesListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - PreferencesListResponse
struct PreferencesListResponse: Codable {
    var code: Int?
    var message: String?
    var data: PreferencesListResponseData?
    var error: [String]?
}


// MARK: - PreferencesListResponseData
struct PreferencesListResponseData: Codable {
    
    var concepts : [PreferencesListConcepts]?
    var categories : [PreferencesListCategories]?
    
}

// MARK: - PreferencesListConcepts
struct PreferencesListConcepts: Codable {
    
    var id: Int?
    var name : String?
    var image : String?
    var isPrefered : Int?
    
    enum CodingKeys : String, CodingKey{
        case id, name, image
        case isPrefered = "is_prefered"
    }
    
}

// MARK: - PreferencesListCategories
struct PreferencesListCategories: Codable {
    
    var id : Int?
    var name : String?
    var image : String?
    var isPrefered : Int?
    
    enum CodingKeys : String, CodingKey{
        case id, name, image
        case isPrefered = "is_prefered"
    }
    
}
