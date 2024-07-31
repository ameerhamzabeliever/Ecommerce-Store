//
//  AddToFavoriteViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 18/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AddToFavoriteViewModelDelegate{
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToAddRecipeToFavoriteListWith(error: [String]?,at IndexPath: Int)
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToFoodItemToFavoriteListWith(error: [String]?,at IndexPath: Int)
    func didAddProductToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int)
    func didFailToAddProductToFavoriteListWith(error: [String]?,at IndexPath: Int)
}

struct AddToFavoriteViewModel{
    
    var delegate: AddToFavoriteViewModelDelegate?
    private var resource = AddToFavoriteResource()
    
    func addRecipeToFavoriteList(request: AddRecipeToFavoriteRequest,indexPath: Int){
        
        resource.addRecipeToFavoriteBy(request: request) { result, status in
            guard let response = result else {
                self.delegate?.didFailToAddRecipeToFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToAddRecipeToFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didAddRecipeToFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
    func addFoodItemToFavoriteList(request: AddFoodItemToFavoriteRequest,indexPath: Int){
        
        resource.addFoodItemToFavoriteBy(request: request) { result, status in
            guard let response = result else {
                self.delegate?.didFailToFoodItemToFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToFoodItemToFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didAddFoodItemToFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
    func addProductToFavoriteList(request: AddProductToFavoriteRequest,indexPath: Int){
        
        resource.addProductToFavoriteBy(request: request) { result, status in
            guard let response = result else {
                self.delegate?.didFailToAddProductToFavoriteListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToAddProductToFavoriteListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didAddProductToFavoriteList(response: response, at: indexPath)
            }
        }
        
    }
    
}


extension AddToFavoriteViewModelDelegate{
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToAddRecipeToFavoriteListWith(error: [String]?,at IndexPath: Int) {}
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToFoodItemToFavoriteListWith(error: [String]?,at IndexPath: Int) {}
    func didAddProductToFavoriteList(response: AddToFavoriteResponse,at indexPath: Int) {}
    func didFailToAddProductToFavoriteListWith(error: [String]?,at IndexPath: Int) {}
}
