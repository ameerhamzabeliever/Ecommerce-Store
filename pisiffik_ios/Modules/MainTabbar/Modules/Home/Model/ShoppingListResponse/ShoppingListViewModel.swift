//
//  ShoppingListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol ShoppingListViewModelDelegates: BaseProtocol{
    func didReceiveShoppingList(response: ShoppingListResponse)
    func didReceiveShoppingListResponseWith(error: [String]?,statusCode: Int?)
    func didReceiveClearAllShoppingList(response: BaseResponse)
    func didReceiveClearAllShoppingListResponseWith(error: [String]?,statusCode: Int?)
    func didReceiveModifyProduct(response: ModifyProductResponse,at indexPath: Int)
    func didReceiveModifyProductResponseWith(error: [String]?, statusCode: Int?)
}

struct ShoppingListViewModel{
    
    var delegate : ShoppingListViewModelDelegates?
    private let resource = ShoppingListResource()
    
    func getShoppingList(){
        
        resource.getShoppingList { response, statusCode in
            guard let response = response else {
                self.delegate?.didReceiveShoppingListResponseWith(error: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                return
            }
            if response.error != nil{
                self.delegate?.didReceiveShoppingListResponseWith(error: response.error, statusCode: statusCode)
            }else{
                self.delegate?.didReceiveShoppingList(response: response)
            }
        }
        
    }
    
    func clearAllShoppingList(){
        
        resource.clearAllShoppingList { result, statusCode in
            guard let response = result else {
                self.delegate?.didReceiveClearAllShoppingListResponseWith(error: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                return
            }
            if response.error != nil{
                self.delegate?.didReceiveClearAllShoppingListResponseWith(error: response.error, statusCode: statusCode)
            }else{
                self.delegate?.didReceiveClearAllShoppingList(response: response)
            }
        }
        
    }
    
    func modifyProductQuantity(variantID: Int,modifyType: Int, at indexPath: Int){
        
        let request = ModifyProductRequest(modifyType: modifyType, variantID: variantID)
        
        resource.modifyProductQuantity(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.modifyProductQuantity,indexPath: indexPath)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveModifyProductResponseWith(error: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveModifyProductResponseWith(error: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveModifyProduct(response: result, at: indexPath)
                    }
                    
                }
                
            }
            
        }
    }
    
}
