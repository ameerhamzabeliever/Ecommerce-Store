//
//  SignupResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import Combine

struct SignupResource {
    
    private let registerEndPoint : String = "/customer/register"
    private let verifyOTPEndPoint : String = "/customer/verifyOTP"
    private let resendOTPPhoneEndPoint : String = "/customer/resendOTP"
    private let verifyEmailOTPEndPoint : String = "/customer/verifyEmailOTP"
    private let resendEmailOTPEndPoint : String = "/customer/resendEmailOTP"
    
    func registerUser(signupRequest: SignupRequest, completion : @escaping (_ result: AuthResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let signupPostBody = try signupRequest.asDictionary()
            
            NetworkManager.postRequest(endPoint: registerEndPoint, params: signupPostBody, dataModel: AuthResponse.self) { results, statusCode in
                
                completion(results, statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
    
    
    func verifyUser(verifyRequest: VerifyPhoneRequest, completion : @escaping (_ result: VerifyResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let verifyPostBody = try verifyRequest.asDictionary()
            
            NetworkManager.postRequest(endPoint: verifyOTPEndPoint, params: verifyPostBody, dataModel: VerifyResponse.self) { results, statusCode in
                
                completion(results, statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil, nil)
        }
        
    }
    
    func resendOtpOnPhone(request: ForgotPasswordRequest, completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let verifyPostBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: resendOTPPhoneEndPoint, params: verifyPostBody, dataModel: BaseResponse.self) { results, statusCode in
                
                completion(results, statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil, nil)
        }
        
    }
    
    func verifyEmail(verifyRequest: VerifyEmailRequest, completion : @escaping (_ result: VerifyResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let verifyPostBody = try verifyRequest.asDictionary()
            
            NetworkManager.postRequest(endPoint: verifyEmailOTPEndPoint, params: verifyPostBody, dataModel: VerifyResponse.self) { results, statusCode in
                
                completion(results, statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil, nil)
        }
        
    }
    
    func resendOtpOnEmail(request: ResendOTPEmailRequest, completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let verifyPostBody = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: resendEmailOTPEndPoint, params: verifyPostBody, dataModel: BaseResponse.self) { results, statusCode in
                
                completion(results, statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil, nil)
        }
        
    }
    
}
