//
//  UpdateProfileValidation.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdateProfileValidation {

    func Validate(request: UpdateProfileRequest) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if(request.full_name.isEmpty)
        {
            return ValidationResult(success: false, error: PisiffikStrings.fullNameRequired())
        }

        if request.full_name.count < 2 || request.full_name.count > 30{
            return ValidationResult(success: false, error: PisiffikStrings.fullNameLenghtError())
        }
        
//        if request.full_name.containsNumbers(){
//            return ValidationResult(success: false, error: PisiffikStrings.enterValidFullNameWithoutNumber())
//        }
        
        if request.dob.isEmpty {
            return ValidationResult(success: false, error: PisiffikStrings.selectDateOfBirth())
        }
        
        if request.gender_id == 0{
            return ValidationResult(success: false, error: PisiffikStrings.selectYourGender())
        }
        
        if request.email != nil && request.email?.isEmpty == false{
            if let email = request.email , !email.isValidEmail{
                return ValidationResult(success: false, error: PisiffikStrings.enterValidEmail())
            }
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
