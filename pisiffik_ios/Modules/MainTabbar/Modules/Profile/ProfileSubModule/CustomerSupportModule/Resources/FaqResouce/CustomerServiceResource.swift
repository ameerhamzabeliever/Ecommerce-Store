//
//  CustomerServiceResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct CustomerServiceResource{
    
    private let endPoint : String = "/customer/service"
    
    func getCustomerServiceDetail(completion : @escaping (_ result: CustomerServiceResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: CustomerServiceResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
