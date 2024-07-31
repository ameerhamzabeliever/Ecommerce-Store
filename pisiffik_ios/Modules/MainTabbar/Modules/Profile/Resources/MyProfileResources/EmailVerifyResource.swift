//
//  EmailVerifyResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/10/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct EmailVerifyRequest: Codable{
    
    let email: String
    
    enum CodingKeys: String, CodingKey{
        case email
    }
    
}

struct EmailVerifyResource{
    
    private let endPoint : String = "/customer/verify/email"
    
    func verifyEmail(request: EmailVerifyRequest,completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: BaseResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
