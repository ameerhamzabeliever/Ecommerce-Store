//
//  VerifyEmailValidation.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/10/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct VerifyEmailValidation {

    func Validate(request: EmailVerifyRequest) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if request.email.isEmpty{
            return ValidationResult(success: false, error: PisiffikStrings.emailRequired())
        }
        
        if !request.email.isValidEmail{
            return ValidationResult(success: false, error: PisiffikStrings.enterValidEmail())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
