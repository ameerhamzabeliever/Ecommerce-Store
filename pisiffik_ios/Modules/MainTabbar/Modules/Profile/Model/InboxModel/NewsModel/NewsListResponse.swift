//
//  NewsListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - TicketListResponse -

struct NewsListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: NewsListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

// MARK: - NewsListResponseData -

struct NewsListResponseData: Codable {
    
    var currentPage : Int?
    var lastPage : Int?
    var news: [NewsList]?
    
    enum CodingKeys: String, CodingKey{
        case news
        case lastPage = "last_page"
        case currentPage = "current_page"
    }
    
}

struct NewsList: Codable {
    
    var id: Int?
    var title : String?
    var description : String?
    var type : String?
    var isActive : Bool?
    var created_at : String?
    var updated_at : String?
    
    enum CodingKeys: String, CodingKey{
        case id, title, description, type
        case isActive = "is_active"
        case created_at, updated_at
    }
    
}
