//
//  RecipeSearchListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RecipeSearchListViewModelDelegate : BaseProtocol {
    
    func didReceiveRecipeSearchList(response: RecipeListResponse)
    func didReceiveRecipeSearchListResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct RecipeSearchListViewModel {
    
    var delegate : RecipeSearchListViewModelDelegate?
    
    func getRecipeSearchList(request: RecipeListSearchRequest) {
        
        let resource = RecipeListSearchResource()
        
        resource.getRecipeSearchList(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveRecipeSearchListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveRecipeSearchListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveRecipeSearchList(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
