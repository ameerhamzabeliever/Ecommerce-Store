//
//  PreferencesDetailResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - PreferencesDetailResponse -

struct PreferencesDetailResponse: Codable {
    var code: Int?
    var message: String?
    var data: PreferencesDetailResponseData?
    var error: [String]?
}


// MARK: - PreferencesDetailResponseData -

struct PreferencesDetailResponseData: Codable {
    
    var alreadyPrefered : [Int]?
    var mainCategory : [PreferencesDetailCategoryData]?
    var subCategory : PreferencesDetailSubCategoryData?
    
    enum CodingKeys: String, CodingKey{
        case mainCategory = "main_category"
        case subCategory = "sub_category"
        case alreadyPrefered = "already_prefered"
    }
    
}

// MARK: - PreferencesDetailCategoryData -

struct PreferencesDetailCategoryData: Codable {
    
    var id: Int?
    var name : String?
    var image : String?
    var isPrefered : Int?
    var banner : String?
    
    enum CodingKeys : String, CodingKey{
        case id, name, image, banner
        case isPrefered = "is_prefered"
    }
    
}


// MARK: - PreferencesDetailSubCategoryData -

struct PreferencesDetailSubCategoryData: Codable {
    
    var id: Int?
    var name : String?
    var image : String?
    var isPrefered : Int?
    var banner : String?
    var child : [PreferencesDetailSubCategoryData]?
    
    enum CodingKeys : String, CodingKey{
        case id, name, image, child, banner
        case isPrefered = "is_prefered"
    }
    
}


struct PreferencesSubCategoryDataModel{
    var subCategory: PreferencesDetailSubCategoryData
    var isOpen: Bool
}

struct PreferencesSectionModel{
    let title: String
    var checkedImage : Bool
}

//MARK: - GET PREFERENCES BY ID Request -

struct GetPreferencesByIDRequest: Codable{
    
    var mainCategoryId : Int
    
    enum CodingKeys: String, CodingKey{
        case mainCategoryId = "main_category_id"
    }
    
}
