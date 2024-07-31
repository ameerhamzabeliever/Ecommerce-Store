//
//  FindNearbyStoreResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct FindNearbyStoreResource{
    
    private let endPoint : String = "/store/nearby"
    
    func getNearbyStores(request: FindNearbyStoreRequest,completion: @escaping (_ result: FindNearbyStoreResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: FindNearbyStoreResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
