//
//  StateViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol StateViewModelDelegates{
    func didReceive(response: StateResponse)
    func didReceiveStateResponseWith(errorMessage: [String]?,statusCode: Int?)
}


class StateViewModel{
    
    var delegate : StateViewModelDelegates?
    
    func getStatesBy(id: Int){
        StateResource().getStates(request: StateRequest(country_id: id)) { result, statusCode in
            DispatchQueue.main.async {
                guard let response = result else {
                    self.delegate?.didReceiveStateResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveStateResponseWith(errorMessage: response.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceive(response: response)
                }
            }
        }
    }
    
}
