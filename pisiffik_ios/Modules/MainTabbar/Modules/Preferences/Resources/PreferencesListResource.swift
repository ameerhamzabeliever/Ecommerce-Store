//
//  PreferencesListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct PreferencesListResource {
    
    private let endPoint : String = "/customer/preferences/list"
    private let preferencesEndPoint : String = "/customer/preferences"
    
    func getPreferencesList(completion: @escaping (_ result: PreferencesListResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: PreferencesListResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }
    
    func updatePreferences(request: UpdatePreferenceRequest,completion: @escaping (_ result: UpdatePreferencesResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: preferencesEndPoint, params: param, dataModel: UpdatePreferencesResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
