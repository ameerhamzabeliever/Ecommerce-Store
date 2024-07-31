//
//  NotificationListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - NotificationListResponse -

struct NotificationListResponse: Codable {
    var code: Int?
    var message: String?
    var data: NotificationListResponseData?
    var error: [String]?
}


// MARK: - NotificationListResponseData -

struct NotificationListResponseData: Codable {
    var notifications : [NotificationList]
}

// MARK: - NotificationList -

struct NotificationList: Codable {
    
    var id : Int?
    var title : String?
    var body : String?
    var event : String?
    var createdAt : String?
    var isRead : Int?
    var data : String?
    
    enum CodingKeys: String, CodingKey{
        case id, title, body, event, data
        case createdAt = "created_at"
        case isRead = "is_read"
    }
    
}
