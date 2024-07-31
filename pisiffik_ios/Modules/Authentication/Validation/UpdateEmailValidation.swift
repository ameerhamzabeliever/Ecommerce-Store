//
//  UpdateEmailValidation.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdateEmailValidation {

    func Validate(request: UpdateEmailRequest) -> ValidationResult{
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if(request.newEmail.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.newEmailIsRequired())
        }
        
        if(!request.newEmail.isValidEmail){
            return ValidationResult(success: false, error: PisiffikStrings.newEmailIsInValid())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
