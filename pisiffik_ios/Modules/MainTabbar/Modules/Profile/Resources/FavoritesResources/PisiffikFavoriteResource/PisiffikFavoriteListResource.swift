//
//  PisiffikFavoriteListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct PisiffikFavoriteListResource{
    
    private let endPoint : String = "/product/favorite/list"
    
    func getPisiffikFavoriteList(request: PisiffikFavoriteRequest,completion: @escaping (_ result: PisiffikFavoriteResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: PisiffikFavoriteResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
