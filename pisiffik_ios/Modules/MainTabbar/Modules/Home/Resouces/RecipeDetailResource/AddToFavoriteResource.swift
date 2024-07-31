//
//  AddToFavoriteResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 18/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddToFavoriteResource{
    
    private var endPoint : String = "/favorite"
    
    func addRecipeToFavoriteBy(request: AddRecipeToFavoriteRequest,completion: @escaping (_ result: AddToFavoriteResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: AddToFavoriteResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
    func addFoodItemToFavoriteBy(request: AddFoodItemToFavoriteRequest,completion: @escaping (_ result: AddToFavoriteResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: AddToFavoriteResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
    func addProductToFavoriteBy(request: AddProductToFavoriteRequest,completion: @escaping (_ result: AddToFavoriteResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: AddToFavoriteResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
