//
//  RecipeListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RecipeListViewModelDelegate : BaseProtocol {
    
    func didReceiveRecipesList(response: RecipeListResponse)
    func didReceiveRecipesListResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct RecipeListViewModel {
    
    var delegate : RecipeListViewModelDelegate?
    
    func getRecipeList(currentPage: Int,request: RecipeListRequest) {
        
        let resource = RecipeListResource()
        
        resource.getRecipeList(currentPage: currentPage,request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveRecipesListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveRecipesListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveRecipesList(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
