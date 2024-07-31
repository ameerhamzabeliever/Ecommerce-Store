//
//  ResetPasswordViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol ResetPasswordViewModelDelegate {
    func didReceive(response: BaseResponse)
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct ResetPasswordViewModel {
    
    var delegate : ResetPasswordViewModelDelegate?
    
    func resetPassword(request: ResetPasswordRequest){
        
        let resource = ResetPasswordResource()
        
        resource.resetPassword(request: request) { result, statusCode in
            DispatchQueue.main.async {
                
                if statusCode == nil || statusCode ?? 0 >= 500 || statusCode == 429 {
                    self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                guard let apiResponse = result else{
                    self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if apiResponse.error != nil{
                    self.delegate?.didReceiveResponseWith(errorMessage: apiResponse.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceive(response: apiResponse)
                }
                
            }
        }
        
        
    }
    
}



extension ResetPasswordViewModelDelegate {
    func didReceive(response: BaseResponse) {}
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?) {}
}
