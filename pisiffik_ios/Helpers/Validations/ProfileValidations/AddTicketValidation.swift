//
//  AddTicketValidation.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddTicketValidation {

    func Validate(request: AddTicketRequest) -> ValidationResult
    {
        if !Network.isAvailable{
            return ValidationResult(success: false, error: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain())
        }
        
        if(request.reason == "")
        {
            return ValidationResult(success: false, error: PisiffikStrings.reasonRequired())
        }

        if request.subject.isEmpty{
            return ValidationResult(success: false, error: PisiffikStrings.subjectRequired())
        }
        
        if request.message.isEmpty{
            return ValidationResult(success: false, error: PisiffikStrings.messageRequired())
        }
        
        return ValidationResult(success: true, error: nil)
    }

}
