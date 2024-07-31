//
//  RecipeDetailResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct RecipeDetailResource{
    
    private var endPoint : String = "/recipe/detail/"
    
    func getRecipesResponse(id: Int,completion: @escaping (_ result: RecipeDetailResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: "\(endPoint)\(id)", dataModel: RecipeDetailResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
