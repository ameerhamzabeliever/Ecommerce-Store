//
//  PissifikFavoriteViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol PissifikFavoriteViewModelDelegate : BaseProtocol {
    func didReceivePisiffikFavoriteList(response: PisiffikFavoriteResponse)
    func didReceivePisiffikFavoriteListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct PissifikFavoriteViewModel {
    
    private let resource = PisiffikFavoriteListResource()
    var delegate : PissifikFavoriteViewModelDelegate?
    
    func getPisiffikFavoriteListBy(request: PisiffikFavoriteRequest) {
        
        resource.getPisiffikFavoriteList(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceivePisiffikFavoriteListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceivePisiffikFavoriteListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceivePisiffikFavoriteList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
