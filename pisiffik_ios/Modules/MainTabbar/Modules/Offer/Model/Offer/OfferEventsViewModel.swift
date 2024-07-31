//
//  OfferEventsViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol OfferEventsViewModelDelegate : BaseProtocol {
    func didReceiveOfferEvents(response: OfferEventsBaseResponse)
    func didReceiveOfferEventsResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct OfferEventsViewModel {
    
    var delegate : OfferEventsViewModelDelegate?
    
    func getOfferEvents() {
        
        let offerResource = OfferEventsResource()
        
        offerResource.getOffersData { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveOfferEventsResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveOfferEventsResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveOfferEvents(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
