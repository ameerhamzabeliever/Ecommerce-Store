//
//  RecipiesDetailViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RecipiesDetailViewModelDelegate {
    
    
    func didReceiveRecipesDetail(response: RecipeDetailResponse)
    func didReceiveRecipesDetailResponseWith(errorMessage: [String]?,statusCode: Int?)

}

class RecipiesDetailViewModel {
    
    var delegate: RecipiesDetailViewModelDelegate?
    
    func getRecipeDetail(id: Int){
        
        let resource = RecipeDetailResource()
        
        resource.getRecipesResponse(id: id) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let apiResponse = result else {
                    self.delegate?.didReceiveRecipesDetailResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()],statusCode: statusCode)
                    return
                }
                
                if apiResponse.error != nil{
                    self.delegate?.didReceiveRecipesDetailResponseWith(errorMessage: apiResponse.error,statusCode: statusCode)
                }else{
                    self.delegate?.didReceiveRecipesDetail(response: apiResponse)
                }
                
            }
        }
        
    }
    
}
