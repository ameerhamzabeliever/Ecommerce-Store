//
//  UpdateEmailViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol UpdateEmailViewModelDelegate {
    func didReceive(response: UpdateEmailResponse)
    func didReceive(errorMessage: [String]?,statusCode: Int?)
}

struct UpdateEmailViewModel {
    
    var delegate : UpdateEmailViewModelDelegate?

    func updateEmail(request: UpdateEmailRequest) {
        
        let validationResult = UpdateEmailValidation().Validate(request: request)

        if(validationResult.success) {
            //use loginResource to call login API
            let resource = UpdateEmailResource()
            
            resource.updateEmail(request: request) { (response, statusCode) in

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
