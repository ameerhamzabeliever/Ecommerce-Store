//
//  AllDigitalNewpapersViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/11/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AllDigitalNewpapersViewModelDelegate : BaseProtocol {
    func didReceiveAllDigitalNewpapers(response: NewspaperResponse)
    func didReceiveAllDigitalNewpapersResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct AllDigitalNewpapersViewModel {
    
    var delegate : AllDigitalNewpapersViewModelDelegate?
    
    func getAllDigitalNewspapers() {
        
        let offerResource = AllDigitalNewspaperResource()
        
        offerResource.getAllDigitalNewspapers { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveAllDigitalNewpapersResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveAllDigitalNewpapersResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAllDigitalNewpapers(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
