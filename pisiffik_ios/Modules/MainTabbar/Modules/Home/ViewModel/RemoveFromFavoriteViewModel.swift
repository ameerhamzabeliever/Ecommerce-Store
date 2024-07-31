//
//  RemoveFromFavoriteViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RemoveFromFavoriteViewModelDelegate{
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?,at IndexPath: Int)
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?,at IndexPath: Int)
    func didRemoveProductFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToRemoveProductFromFavoriteListWith(error: [String]?,at IndexPath: Int)
}

struct RemoveFromFavoriteViewModel{
    
    var delegate: RemoveFromFavoriteViewModelDelegate?
    private var resource = RemoveFromFavoriteResource()
    
    func removeRecipeFromFavoriteList(request: AddRecipeToFavoriteRequest,indexPath: Int){
        
        resource.removeRecipeFromFavoriteBy(request: request) { result, statusCode in
            guard let response = result else {
                self.delegate?.didFailToRemoveRecipeFromFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToRemoveRecipeFromFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didRemoveRecipeFromFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
    func removeFoodItemFromFavoriteList(request: AddFoodItemToFavoriteRequest,indexPath: Int){
        
        resource.removeFoodItemFromFavoriteBy(request: request) { result, statusCode in
            guard let response = result else {
                self.delegate?.didFailToRemoveFoodItemFromFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToRemoveFoodItemFromFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didRemoveFoodItemFromFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
    func removeProductFromFavoriteList(request: AddProductToFavoriteRequest,indexPath: Int){
        
        resource.removeProductFromFavoriteBy(request: request) { result, statusCode in
            guard let response = result else {
                self.delegate?.didFailToRemoveProductFromFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToRemoveProductFromFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didRemoveProductFromFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
}


extension RemoveFromFavoriteViewModelDelegate{
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?,at IndexPath: Int) {}
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?,at IndexPath: Int) {}
    func didRemoveProductFromFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToRemoveProductFromFavoriteListWith(error: [String]?,at IndexPath: Int) {}
}
