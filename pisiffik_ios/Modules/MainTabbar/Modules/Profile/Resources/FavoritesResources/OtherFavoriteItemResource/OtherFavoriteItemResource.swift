//
//  OtherFavoriteItemResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct OtherFavoriteItemResource{
    
    private let endPoint : String = "/product/favorite/list"
    
    func getPisiffikFavoriteList(completion: @escaping (_ result: OtherFavoriteItemResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.postRequest(endPoint: endPoint, params: nil, dataModel: OtherFavoriteItemResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
