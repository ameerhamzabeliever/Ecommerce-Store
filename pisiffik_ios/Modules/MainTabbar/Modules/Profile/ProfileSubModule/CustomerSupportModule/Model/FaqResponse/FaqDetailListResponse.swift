//
//  FaqDetailListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct FaqDetailListResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: FaqDetailListResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}

struct FaqDetailListResponseData: Codable {
    var faqs : [Faqs]?
}

struct Faqs: Codable {
 
    var id: Int?
    var question: String?
    var answer: String?

}
