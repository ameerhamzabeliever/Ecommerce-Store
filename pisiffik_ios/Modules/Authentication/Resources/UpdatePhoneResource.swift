//
//  UpdatePhoneResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdatePhoneResource {
    
    private let endPoint : String = "/customer/phoneUpdate"
    
    func updatePhone(request: UpdatePhoneRequest, completion : @escaping (_ result: UpdatePhoneResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let requestBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: requestBody, dataModel: UpdatePhoneResponse.self) { results, statusCode in
                
               completion(results,statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
}
