//
//  FaqListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct FaqListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: FaqListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct FaqListResponseData: Codable {
 
    var faqList : [FaqList]?

    enum CodingKeys: String, CodingKey {
        case faqList = "faq_type_list"
    }
}

struct FaqList: Codable {
 
    var id: Int?
    var name: String?
    var icon: String?

    enum CodingKeys: String, CodingKey {
        case id, name, icon
    }
}
