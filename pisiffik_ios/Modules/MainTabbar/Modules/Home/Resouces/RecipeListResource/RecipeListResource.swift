//
//  RecipeListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct RecipeListResource{
    
    private let endPoint : String = "/recipe/list?page="
    
    func getRecipeList(currentPage: Int,request: RecipeListRequest,completion: @escaping (_ result: RecipeListResponse?, _ status: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint + "\(currentPage)", params: param, dataModel: RecipeListResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil,nil)
        }
        
        
    }
    
    
}
