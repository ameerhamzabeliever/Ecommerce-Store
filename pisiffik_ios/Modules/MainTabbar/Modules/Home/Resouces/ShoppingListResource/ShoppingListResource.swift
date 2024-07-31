//
//  ShoppingListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct ShoppingListResource{
    
    private let shoppingListEndPoint : String = "/shoppoingList/show"
    private let clearListEndPoint : String = "/shoppoingList/clearShoppigList"
    private let modifyProductQuantityEndPoint : String = "/shoppoingList/modifyProductQuantity"
    
    func getShoppingList(completion: @escaping (_ result: ShoppingListResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: shoppingListEndPoint, dataModel: ShoppingListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
    func clearAllShoppingList(completion: @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void){
        NetworkManager.getRequest(endPoint: clearListEndPoint, dataModel: BaseResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
    }
    
    func modifyProductQuantity(request: ModifyProductRequest,completion: @escaping (_ result: ModifyProductResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: modifyProductQuantityEndPoint, params: param, dataModel: ModifyProductResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
