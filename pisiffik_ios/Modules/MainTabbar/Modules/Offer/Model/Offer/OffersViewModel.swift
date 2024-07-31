//
//  OffersViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 18/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol OffersViewModelDelegate : BaseProtocol {
    func didReceiveOffers(response: OfferResponse)
    func didReceiveOffersResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct OffersViewModel {
    
    var delegate : OffersViewModelDelegate?
    
    func getOffers(with request: OfferRequest) {
        
        let offerResource = OfferResource()
        
        offerResource.getOffersData(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveOffersResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveOffersResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveOffers(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
