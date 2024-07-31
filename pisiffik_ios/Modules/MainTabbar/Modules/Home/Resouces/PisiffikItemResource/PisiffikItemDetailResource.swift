//
//  PisiffikItemDetailResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct PisiffikItemDetailResource{
    
    private var endPoint : String = "/product/detail"
    
    func getPisiffikItemDetailResponse(request: PisiffikItemDetailRequest,completion: @escaping (_ result: PisiffikItemDetailResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint,params: param, dataModel: PisiffikItemDetailResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
