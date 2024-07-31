//
//  UpdateEmailResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct UpdateEmailResource {
    
    private let endPoint : String = "/customer/emailUpdate"
    
    func updateEmail(request: UpdateEmailRequest, completion : @escaping (_ result: UpdateEmailResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let requestBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: requestBody, dataModel: UpdateEmailResponse.self) { results, statusCode in
                
               completion(results,statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
}
