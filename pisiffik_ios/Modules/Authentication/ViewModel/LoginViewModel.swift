//
//  LoginViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate {
    
    func didReceive(response: AuthResponse)
    func didReceive(errorMessage: [String]?,statusCode: Int?)

}

struct LoginViewModel {
    var delegate : LoginViewModelDelegate?

    func loginUser(loginRequest: LoginValidationRequest,countryCode: String,isValidPhone: Bool) {
        let validationResult = LoginValidation().Validate(loginRequest: loginRequest,countryCode: countryCode,isValidPhone: isValidPhone)

        if(validationResult.success) {
            //use loginResource to call login API
            let loginResource = LoginResource()
            
            let phoneNmb = loginRequest.phone.replacingOccurrencesOfWhiteSpaces()
            let email = loginRequest.email.replacingOccurrencesOfWhiteSpaces()
            let newRequest = LoginValidationRequest(phone: phoneNmb, email: email, password: loginRequest.password, fcm_token: loginRequest.fcm_token)
            
            loginResource.loginUser(loginRequest: newRequest,isValidPhone: isValidPhone) { (loginApiResponse, statusCode) in

                //return the response we get from loginResource
                DispatchQueue.main.async {
                    
                    if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                        self.delegate?.didReceive(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                        return
                    }
                    
                    guard let loginApiResponse = loginApiResponse else {
                        self.delegate?.didReceive(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                        return
                    }
                    
                    if loginApiResponse.error != nil {
                        self.delegate?.didReceive(errorMessage: loginApiResponse.error,statusCode: statusCode)
                    } else {
                        self.delegate?.didReceive(response: loginApiResponse)
                    }
                    
                }
            }
        }else{
            self.delegate?.didReceive(errorMessage: [validationResult.error ?? ""],statusCode: nil)
        }
        
    }
}
