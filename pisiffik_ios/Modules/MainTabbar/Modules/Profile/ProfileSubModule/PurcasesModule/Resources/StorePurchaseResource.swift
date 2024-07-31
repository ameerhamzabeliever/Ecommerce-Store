//
//  StorePurchaseResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct StorePurchaseResource{
    
    func getStorePurchaseDetail(with id: Int,mode: StorePurchaseMode,completion : @escaping (_ result: StorePurchaseResponse?,_ statusCode: Int?) -> Void) {
        
        var endPoint : String = ""
        if mode == .purchase{
            endPoint = "/customer/purchase/detail/\(id)"
        }else{
            endPoint = "/customer/points/detail/\(id)"
        }
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: StorePurchaseResponse.self) { results, statusCode in
            completion(results , statusCode)
        }

    }
    
}
