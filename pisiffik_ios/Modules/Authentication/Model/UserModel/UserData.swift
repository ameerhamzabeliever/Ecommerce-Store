//
//  UserData.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - User

struct UserData: Codable {
    
    var id : String?
    var fullName : String?
    var phone: String?
    var email: String?
    var fcmToken: String?
    var emailVerifiedAt: String?
    var dob: String?
    var country: Description?
    var gender: Description?
    var state: Description?
    var city: Description?
    var address: String?
    var deviceType: String?
    var latitude: Double?
    var longitude: Double?
    var otp: Int?
    var isVerified: Bool?
    var rememberToken: String?
    var deletedAt: String?
    var createdAt: String?
    var updatedAt: String?
    var token: String?
    var phoneVerify: Int?
    var emailVerify: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case phone, email
        case fcmToken = "fcm_token"
        case emailVerifiedAt = "email_verified_at"
        case dob
        case country
        case gender
        case state
        case city
        case address
        case deviceType = "device_type"
        case latitude, longitude, otp
        case isVerified = "is_verified"
        case rememberToken = "remember_token"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case token
        case phoneVerify = "phone_verify"
        case emailVerify = "email_verify"
    }
    
}


struct Description: Codable{
    
    var id : Int?
    var name : String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}
