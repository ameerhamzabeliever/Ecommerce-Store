//
//  BaseResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - BaseResponse
struct BaseResponse: Codable {
    
    var responseCode: Int = 0
    var responseMessage: String? = ""
    var data: BaseResponseData?
    var error: [String]?

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case responseMessage = "message"
        case data
        case error
    }
}


struct BaseResponseData: Codable{
    
}
