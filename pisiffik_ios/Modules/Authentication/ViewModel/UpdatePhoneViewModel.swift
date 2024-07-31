//
//  UpdatePhoneViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol UpdatePhoneViewModelDelegate {
    func didReceive(response: UpdatePhoneResponse)
    func didReceive(errorMessage: [String]?,statusCode: Int?)
}

struct UpdatePhoneViewModel {
    
    var delegate : UpdatePhoneViewModelDelegate?

    func updatePhone(request: UpdatePhoneRequest,isValidPhone: Bool) {
        
        let validationResult = UpdatePhoneValidation().Validate(request: request,isValid: isValidPhone)

        if(validationResult.success) {
            //use loginResource to call login API
            let resource = UpdatePhoneResource()
            
            resource.updatePhone(request: request) { (response, statusCode) in

                //return the response we get from loginResource
                DispatchQueue.main.async {
                    
                    if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                        self.delegate?.didReceive(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                        return
                    }
                    
                    guard let response = response else {
                        self.delegate?.didReceive(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                        return
                    }
                    
                    if response.error != nil {
                        self.delegate?.didReceive(errorMessage: response.error,statusCode: statusCode)
                    } else {
                        self.delegate?.didReceive(response: response)
                    }
                    
                }
            }
        }else{
            self.delegate?.didReceive(errorMessage: [validationResult.error ?? ""],statusCode: nil)
        }
        
    }
}
