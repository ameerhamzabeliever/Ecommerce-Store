//
//  AllOffersViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

enum MyOfferBenefitType: String{
    case personal
    case local
    case memberships = "membership"
}

protocol AllOffersViewModelDelegate: BaseProtocol {
    func didReceiveAllOffers(response: AllOffersResponse)
    func didReceiveAllOffersResponseWith(errorMessage: [String]?,statusCode: Int?)
}

class AllOffersViewModel {
    
    var delegate: AllOffersViewModelDelegate?
    
    func getAllOffersWith(request: AllOffersRequest){
        
        let resource = AllOffersResource()
        
        resource.getAllOffersWith(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveAllOffersResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveAllOffersResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAllOffers(response: result)
                    }
                    
                }
                
            }
        }
        
    }
    
}
