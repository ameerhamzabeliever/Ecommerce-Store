//
//  LoginResource.swift
//  pisiffik-ios
//
//  Created by Haider Ali on 23/05/2022.
//  Copyright © 2022 softwarealliance.dk. All rights reserved.
//

import Foundation
import Combine

struct LoginResource {
    
    private let loginEndPoint : String = "/customer/login"
    
    func loginUser(loginRequest: LoginValidationRequest,isValidPhone: Bool, completion : @escaping (_ result: AuthResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            var request = LoginRequest(password: loginRequest.password, fcm_token: loginRequest.fcm_token)
            
            if isValidPhone{
                request.phone = loginRequest.phone
            }else if !loginRequest.email.isEmpty{
                request.email = loginRequest.email
            }
            
            let loginPostBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: loginEndPoint, params: loginPostBody, dataModel: AuthResponse.self) { results, statusCode in
                
               completion(results,statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
}
