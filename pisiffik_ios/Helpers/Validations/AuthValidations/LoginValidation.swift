//
//  LoginValidation.swift
//  pisiffik-ios
//
//  Created by Haider Ali on 23/05/2022.
//  Copyright © 2022 softwarealliance.dk. All rights reserved.
//

import Foundation

struct LoginValidation {

    func Validate(loginRequest: LoginValidationRequest,countryCode: String,isValidPhone: Bool) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if(loginRequest.phone == countryCode && loginRequest.email.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.pleaseTypePhoneNmbOrEmailError())
        }
        
        if ((loginRequest.phone != countryCode || loginRequest.phone.count > countryCode.count) && !isValidPhone){
            return ValidationResult(success: false, error: PisiffikStrings.enterValidNumber())
        }
        
        if (!loginRequest.email.isEmpty && !loginRequest.email.isValidEmail){
            return ValidationResult(success: false, error: PisiffikStrings.enterValidEmail())
        }

        if(loginRequest.password.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.passwordMustRequired())
        }

        if (loginRequest.password.count < 6) {
            return ValidationResult(success: false, error: PisiffikStrings.passwordShouldBe6Characters())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
