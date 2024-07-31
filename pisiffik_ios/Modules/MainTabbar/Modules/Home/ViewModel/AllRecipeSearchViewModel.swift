//
//  AllRecipeSearchViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AllRecipeSearchViewModelDelegate : BaseProtocol {
    
    func didReceiveAllRecipesSearchList(response: AllRecipeRespone)
    func didReceiveAllRecipesSearchListResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct AllRecipeSearchViewModel {
    
    var delegate : AllRecipeSearchViewModelDelegate?
    
    func getAllRecipesSearchList(request: AllRecipeCategoriesSearchRequest) {
        
        let resource = AllRecipeSearchResource()
        
        resource.getAllRecipesSearchList(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveAllRecipesSearchListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveAllRecipesSearchListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAllRecipesSearchList(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
