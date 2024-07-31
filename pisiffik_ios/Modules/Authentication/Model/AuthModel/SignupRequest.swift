//
//  SignupRequest.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct SignupRequest: Codable {
    
    var fullName: String
    var phone: String
    var email: String
    var password: String
    var deviceType: String
    var fcmToken: String
    
    enum CodingKeys: String, CodingKey{
        case fullName = "full_name"
        case phone, email
        case password
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
    }
    
}


struct VerifyPhoneRequest: Codable{
    
    let otp : String
    let phone : String
    
    enum CodingKeys: String, CodingKey{
        case otp
        case phone
    }
    
}

struct ForgotPasswordRequest: Codable{
    
    let phone : String
    
    enum CodingKeys: String, CodingKey{
        case phone
    }
    
}

struct ResetPasswordRequest: Codable{
    
    let password : String
    
    enum CodingKeys: String, CodingKey{
        case password
    }
    
}

struct VerifyEmailRequest: Codable{
    
    let otp : String
    let email : String
    
    enum CodingKeys: String, CodingKey{
        case otp = "email_otp"
        case email
    }
    
}


struct ResendOTPEmailRequest: Codable{
    
    let email : String
    
    enum CodingKeys: String, CodingKey{
        case email
    }
    
}
