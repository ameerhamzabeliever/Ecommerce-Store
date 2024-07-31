//
//  RemovePreferenceResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

final class RemovePreferenceResource {
    
    private var endPoint : String = "/customer/preferences/remove"
    
    func removePreferenceBy(request: RemoveCategoryRequest,completion: @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: BaseResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
