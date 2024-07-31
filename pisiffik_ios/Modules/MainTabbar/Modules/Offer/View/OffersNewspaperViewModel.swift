//
//  OffersNewspaperViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/11/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol OffersNewspaperViewModelDelegate : BaseProtocol {
    func didReceiveDigitalNewpapers(response: NewspaperResponse)
    func didReceiveDigitalNewpapersResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct OffersNewspaperViewModel {
    
    var delegate : OffersNewspaperViewModelDelegate?
    
    func getDigitalNewspapers() {
        
        let offerResource = OffersNewpaperResource()
        
        offerResource.getDigitalNewspaperList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveDigitalNewpapersResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveDigitalNewpapersResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveDigitalNewpapers(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
