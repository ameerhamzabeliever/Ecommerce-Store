//
//  UpdatePhoneValidation.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdatePhoneValidation {

    func Validate(request: UpdatePhoneRequest,isValid: Bool) -> ValidationResult{
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if (request.newPhone.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.newPhoneIsRequired())
        }
        
        if (!isValid){
            return ValidationResult(success: false, error: PisiffikStrings.newPhoneIsInValid())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
