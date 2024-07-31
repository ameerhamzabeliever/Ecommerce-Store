//
//  ResetPasswordValidation.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct ResetPasswordValidation {

    func Validate(password: String,confirmPassword: String) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if (password.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.passwordMustRequired())
        }
        
        if(password.count < 6){
            return ValidationResult(success: false, error: PisiffikStrings.passwordShouldBe6Characters())
        }
        
        if (confirmPassword.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.confirmPasswordMustRequired())
        }
        
        if (confirmPassword.count < 6){
            return ValidationResult(success: false, error: PisiffikStrings.confirmPasswordShouldBe6Characters())
        }
        
        if (password != confirmPassword){
            return ValidationResult(success: false, error: PisiffikStrings.bothPasswordMustBeMatched())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
