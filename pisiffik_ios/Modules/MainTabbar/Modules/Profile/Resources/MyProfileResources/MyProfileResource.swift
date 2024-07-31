//
//  MyProfileResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct MyProfileResource{
    
    private let endPoint : String = "/customer/updateProfile"
    
    func updateProfile(request: UpdateProfileRequest,completion : @escaping (_ result: UpdateProfileResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: UpdateProfileResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
