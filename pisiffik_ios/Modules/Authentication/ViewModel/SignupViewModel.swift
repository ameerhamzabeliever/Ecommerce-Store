//
//  SignupViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

enum SignMode{
    case fromLogin
    case fromSignup
    case fromForgotPassword
    case fromMyProfile
}


protocol SignupViewModelDelegate {
    func didReceiveSignup(response: AuthResponse)
    func didReceiveSignup(errorMessage: [String]?,statusCode: Int?)
    func didReceiveVerify(response: VerifyResponse)
    func didReceiveVerify(errorMessage: [String]?,statusCode: Int?)
    func didReceiveResendOTP(response: BaseResponse)
    func didReceiveResendOTP(errorMessage: [String]?,statusCode: Int?)
}

struct SignupViewModel {
    
    var delegate : SignupViewModelDelegate?

    func registerUser(signupRequest: SignupRequest,isValidPhone: Bool) {
        let validationResult = SignupValidation().Validate(signupRequest: signupRequest,isValidPhone: isValidPhone)

        if(validationResult.success) {
            //use signupResource to call login API
            let signupResource = SignupResource()
            
            let phoneNmb = signupRequest.phone.replacingOccurrencesOfWhiteSpaces()
            let newRequest = SignupRequest(fullName: signupRequest.fullName, phone: phoneNmb, email: signupRequest.email, password: signupRequest.password, deviceType: signupRequest.deviceType, fcmToken: signupRequest.fcmToken)
            
            signupResource.registerUser(signupRequest: newRequest) { result, statusCode in
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveSignup(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                guard let response = result else {
                    self.delegate?.didReceiveSignup(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveSignup(errorMessage: response.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveSignup(response: response)
                }
            }
            
        }else{
            self.delegate?.didReceiveSignup(errorMessage: [validationResult.error ?? ""], statusCode: nil)
        }
        
    }
    
    func verifyPhone(request: VerifyPhoneRequest){
        
        let signupResource = SignupResource()
        
        signupResource.verifyUser(verifyRequest: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveVerify(errorMessage: result?.error,statusCode: statusCode)
                    return
                }
                
                guard let response = result else {
                    self.delegate?.didReceiveVerify(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveVerify(errorMessage: response.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveVerify(response: response)
                }
                
            }
            
        }
        
    }
    
    func resendCodeOnPhone(request: ForgotPasswordRequest){
        
        let signupResource = SignupResource()
        
        signupResource.resendOtpOnPhone(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveResendOTP(errorMessage: result?.error,statusCode: statusCode)
                    return
                }
                
                guard let response = result else {
                    self.delegate?.didReceiveResendOTP(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveResendOTP(errorMessage: response.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveResendOTP(response: response)
                }
                
            }
            
        }
        
    }
    
    func verifyEmail(request: VerifyEmailRequest){
        
        let signupResource = SignupResource()
        
        signupResource.verifyEmail(verifyRequest: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveVerify(errorMessage: result?.error,statusCode: statusCode)
                    return
                }
                
                guard let response = result else {
                    self.delegate?.didReceiveVerify(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveVerify(errorMessage: response.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveVerify(response: response)
                }
                
            }
            
        }
        
    }
    
    func resendCodeOnEmail(request: ResendOTPEmailRequest){
        
        let signupResource = SignupResource()
        
        signupResource.resendOtpOnEmail(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveResendOTP(errorMessage: result?.error,statusCode: statusCode)
                    return
                }
                
                guard let response = result else {
                    self.delegate?.didReceiveResendOTP(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveResendOTP(errorMessage: response.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveResendOTP(response: response)
                }
                
            }
            
        }
        
    }
    
}



extension SignupViewModelDelegate {
    func didReceiveSignup(response: AuthResponse) {}
    func didReceiveSignup(errorMessage: [String]?,statusCode: Int?) {}
    func didReceiveVerify(response: VerifyResponse) {}
    func didReceiveVerify(errorMessage: [String]?,statusCode: Int?) {}
    func didReceiveResendOTP(response: BaseResponse) {}
    func didReceiveResendOTP(errorMessage: [String]?,statusCode: Int?) {}
}
