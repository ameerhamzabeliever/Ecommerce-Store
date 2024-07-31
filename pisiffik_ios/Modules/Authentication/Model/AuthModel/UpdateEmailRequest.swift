//
//  UpdateEmailRequest.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdateEmailRequest: Codable{
    
    let oldEmail : String
    let newEmail : String
    
    enum CodingKeys: String, CodingKey{
        case oldEmail = "old_email"
        case newEmail = "new_email"
    }
    
}
