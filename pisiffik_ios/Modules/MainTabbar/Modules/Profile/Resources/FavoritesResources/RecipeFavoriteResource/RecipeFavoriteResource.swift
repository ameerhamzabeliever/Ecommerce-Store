//
//  RecipeFavoriteResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct RecipeFavoriteResource{
    
    private let endPoint : String = "/recipe/favorite/list?page="
    
    func getRecipeFavoriteList(currentPage: Int,completion : @escaping (_ result: RecipeFavoriteResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: endPoint + "\(currentPage)", dataModel: RecipeFavoriteResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
