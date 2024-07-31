//
//  HomeViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate : BaseProtocol {
    
    func didReceiveHome(response: HomeResponse)
    func didReceiveHomeResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct HomeViewModel {
    
    var delegate : HomeViewModelDelegate?
    
    func homeRequest() {
        
        let homeResource = HomeResource()
        
        homeResource.getHomeResponse { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveHomeResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveHomeResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveHome(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
