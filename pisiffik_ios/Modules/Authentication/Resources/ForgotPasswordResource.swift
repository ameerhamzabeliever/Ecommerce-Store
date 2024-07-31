//
//  ForgotPasswordResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct ForgotPasswordResource {
    
    private let endPoint : String = "/customer/resendOTP"
    
    func forgotPassword(request: ForgotPasswordRequest, completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let requestPostBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: requestPostBody, dataModel: BaseResponse.self) { results, statusCode in
                
                completion(results,statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
}
