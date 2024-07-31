//
//  LogoutViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 12/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol LogoutViewModelDelegates{
    func didReceiveLogout(response: BaseResponse)
    func didReceiveLogoutResponseWith(errorMessage: [String]?,statusCode: Int?)
}


class LogoutViewModel{
    
    var delegate : LogoutViewModelDelegates?
    
    func logoutUser(){
        
        LogoutResource().logoutUser { result, statusCode in
            DispatchQueue.main.async {
                guard let response = result else {
                    self.delegate?.didReceiveLogoutResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveLogoutResponseWith(errorMessage: response.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveLogout(response: response)
                }
            }
        }
        
    }
    
}
