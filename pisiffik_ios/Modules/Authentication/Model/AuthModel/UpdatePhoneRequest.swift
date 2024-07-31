//
//  UpdatePhoneRequest.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdatePhoneRequest: Codable{
    
    let oldPhone : String
    let newPhone : String
    
    enum CodingKeys: String, CodingKey{
        case oldPhone = "old_phone"
        case newPhone = "new_phone"
    }
    
}
