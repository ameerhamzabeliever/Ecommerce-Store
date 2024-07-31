//
//  CountryViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol CountryViewModelDelegates{
    func didReceive(response: CountryResponse)
    func didReceiveCountryResponseWith(errorMessage: [String]?,statusCode: Int?)
}


class CountryViewModel{
    
    var delegate : CountryViewModelDelegates?
    
    func getCounties(){
        
        CountryResource().getCountries { result, statusCode in
            DispatchQueue.main.async {
                guard let response = result else {
                    self.delegate?.didReceiveCountryResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if response.error != nil{
                    self.delegate?.didReceiveCountryResponseWith(errorMessage: response.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceive(response: response)
                }
            }
        }
        
    }
    

    
}
