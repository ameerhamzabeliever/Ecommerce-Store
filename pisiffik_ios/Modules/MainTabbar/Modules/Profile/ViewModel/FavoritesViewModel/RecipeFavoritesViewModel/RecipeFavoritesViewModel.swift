//
//  RecipeFavoritesViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RecipeFavoritesViewModelDelegate : BaseProtocol {
    func didReceiveRecipeFavoriteList(response: RecipeFavoriteResponse)
    func didReceiveRecipeFavoriteListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct RecipeFavoritesViewModel {
    
    private let resource = RecipeFavoriteResource()
    var delegate : RecipeFavoritesViewModelDelegate?
    
    func getRecipeFavoriteList(currentPage: Int) {
        
        resource.getRecipeFavoriteList(currentPage: currentPage) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveRecipeFavoriteListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveRecipeFavoriteListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveRecipeFavoriteList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
