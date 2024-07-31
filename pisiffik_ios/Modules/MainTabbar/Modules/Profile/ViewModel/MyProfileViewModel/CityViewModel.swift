//
//  CityViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol CityViewModelDelegates{
    func didReceive(response: CityResponse)
    func didReceiveCityResponseWith(errorMessage: [String]?,statusCode: Int?)
}


class CityViewModel{
    
    var delegate : CityViewModelDelegates?
    
    func getCityBy(id: Int){
        CityResource().getStates(request: CityRequest(state_id: id)) { result, statusCode in
            DispatchQueue.main.async {
                guard let response = result else {
                    self.delegate?.didReceiveCityResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveCityResponseWith(errorMessage: response.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceive(response: response)
                }
            }
        }
    }
    
}
