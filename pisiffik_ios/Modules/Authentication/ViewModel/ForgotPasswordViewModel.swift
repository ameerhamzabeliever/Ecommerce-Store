//
//  ForgotPasswordViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol ForgotPasswordViewModelDelegate {
    func didReceive(response: BaseResponse)
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct ForgotPasswordViewModel {
    
    var delegate : ForgotPasswordViewModelDelegate?
    
    func forgotPassword(request: ForgotPasswordRequest){
        
        let resource = ForgotPasswordResource()
        
        resource.forgotPassword(request: request) { result, statusCode in
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                guard let apiResponse = result else{
                    self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                    return
                }
                
                if apiResponse.error != nil{
                    self.delegate?.didReceiveResponseWith(errorMessage: apiResponse.error, statusCode: statusCode)
                }else{
                    self.delegate?.didReceive(response: apiResponse)
                }
                
            }
        }
        
        
    }
    
}



extension SignupViewModelDelegate {
    func didReceive(response: BaseResponse) {}
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?) {}
}
