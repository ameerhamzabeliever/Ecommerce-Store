//
//  SignupValidation.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation


struct SignupValidation {

    func Validate(signupRequest: SignupRequest,isValidPhone: Bool) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if (signupRequest.fullName.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.fullNameRequired())
        }
        
        if signupRequest.fullName.count < 2 || signupRequest.fullName.count > 30{
            return ValidationResult(success: false, error: PisiffikStrings.fullNameLenghtError())
        }
        
//        if !signupRequest.fullName.isValid(fullName: signupRequest.fullName){
//            return ValidationResult(success: false, error: PisiffikStrings.enterValidFullName())
//        }
        
        if(signupRequest.phone.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.mobileNumberRequired())
        }
        
        if isValidPhone == false{
            return ValidationResult(success: false, error: PisiffikStrings.enterValidNumber())
        }
        
        if signupRequest.email.isEmpty{
            return ValidationResult(success: false, error: PisiffikStrings.emailRequired())
        }
        
        if !signupRequest.email.isValidEmail{
            return ValidationResult(success: false, error: PisiffikStrings.enterValidEmail())
        }

        if(signupRequest.password.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.passwordMustRequired())
        }

        if (signupRequest.password.count < 6){
            return ValidationResult(success: false, error: PisiffikStrings.passwordShouldBe6Characters())
        }
        
        if (signupRequest.deviceType.isEmpty){
            return ValidationResult(success: false, error: PisiffikStrings.deviceTypeRequired())
        }
        
        if signupRequest.fcmToken.isEmpty{
            return ValidationResult(success: false, error: PisiffikStrings.fcmTokenRequired())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
