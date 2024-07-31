//
//  AllRecipeResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AllRecipeResource{
    
    private var endPoint : String = "/recipe/categorizedList"
    
    func getAllRecipes(completion: @escaping (_ result: AllRecipeRespone?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: AllRecipeRespone.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
