//
//  AddPisifiikItemToShoppingListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AddPisiffikItemToCartViewModelDelegate{
    func didAddPisiffikItemsToCart(response: AddPisiffikProductToShoppingResponse)
    func didFailToAddPisiffikItemsToCartWith(error: [String]?,at IndexPath: Int)
}

struct AddPisiffikItemToCartViewModel{
    
    var delegate: AddPisiffikItemToCartViewModelDelegate?
    private var resource = AddPisifiikItemToCartListResource()
    
    func addPisiffikItemsToShopping(list: [AddPisiffikProductRequest],indexPath: Int){
        
        let products = AddPisiffikProductToCartRequest(products: list)
        
        resource.addToShoppingList(request: products) { result, status in
            
            guard let response = result else {
                self.delegate?.didFailToAddPisiffikItemsToCartWith(error: [PisiffikStrings.somethingWentWron()], at: indexPath)
                return
            }
            
            if response.error != nil{
                self.delegate?.didFailToAddPisiffikItemsToCartWith(error: response.error, at: indexPath)
            }else{
                self.delegate?.didAddPisiffikItemsToCart(response: response)
            }
            
        }
        
    }
    
}


extension AddToShoppingListViewModelDelegate{
    func didAddPisiffikItemsToShoppingList(response: AddPisiffikProductToShoppingResponse) {}
    func didFailToAddPisiffikItemsToShoppingListWith(error: [String]?,at IndexPath: Int) {}
}
