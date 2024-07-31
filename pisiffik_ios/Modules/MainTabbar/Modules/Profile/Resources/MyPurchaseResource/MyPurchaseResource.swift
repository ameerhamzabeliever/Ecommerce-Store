//
//  MyPurchaseResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct MyPurchaseResource{
    
    private let endPoint : String = "/customer/purchase/list"
    
    func getPurchaseList(with request: MyPurchaseRequest,completion : @escaping (_ result: MyPurchaseResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: MyPurchaseResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
