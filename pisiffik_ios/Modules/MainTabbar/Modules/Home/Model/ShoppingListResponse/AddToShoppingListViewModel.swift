//
//  AddToShoppingListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AddToShoppingListViewModelDelegate{
    func didAddToShoppingList(response: AddPisiffikProductToShoppingResponse)
    func didFailToAddToShoppingListWith(error: [String]?,at IndexPath: Int)
}

struct AddToShoppingListViewModel{
    
    var delegate: AddToShoppingListViewModelDelegate?
    private var resource = AddToSoppingListResource()
    
    func addProductsToShopping(list: [AddToShoppingListRequest],indexPath: Int){
        
        let products = AddToShoppingProductRequest(products: list)
        
        resource.addToShoppingList(request: products) { result, status in
            
            guard let response = result else {
                self.delegate?.didFailToAddToShoppingListWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToAddToShoppingListWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didAddToShoppingList(response: response)
            }
            
        }
        
    }
    
}


extension AddToShoppingListViewModelDelegate{
    func didAddToShoppingList(response: AddPisiffikProductToShoppingResponse) {}
    func didFailToAddToShoppingListWith(error: [String]?,at IndexPath: Int) {}
}
