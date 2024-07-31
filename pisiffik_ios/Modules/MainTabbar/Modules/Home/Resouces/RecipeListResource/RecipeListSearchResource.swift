//
//  RecipeListSearchResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct RecipeListSearchResource{
    
    private let endPoint : String = "/recipe/search"
    
    func getRecipeSearchList(request: RecipeListSearchRequest,completion: @escaping (_ result: RecipeListResponse?, _ status: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: RecipeListResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil,nil)
        }
        
        
    }
    
    
}
