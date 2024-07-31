//
//  AllRecipeViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AllRecipeViewModelDelegate : BaseProtocol {
    
    func didReceiveAllRecipes(response: AllRecipeRespone)
    func didReceiveAllRecipesResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct AllRecipeViewModel {
    
    var delegate : AllRecipeViewModelDelegate?
    
    func getAllRecipes() {
        
        let allRecipeResource = AllRecipeResource()
        
        allRecipeResource.getAllRecipes { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveAllRecipesResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveAllRecipesResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAllRecipes(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
