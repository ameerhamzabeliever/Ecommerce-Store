//
//  MyPointsResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct MyPointsResource{
    
    func getPoints(request: MyPointsRequest,currentPage: Int,completion : @escaping (_ result: MyPointsResponse?,_ statusCode: Int?) -> Void) {
        
        let endPoint : String = "/customer/points/list?page=\(currentPage)"
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: MyPointsResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
