//
//  PreferencesDetailResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

final class PreferencesDetailResource {
    
    private var endPoint : String = "/customer/preferences/all"
    private let preferencesEndPoint : String = "/customer/preferences"
    
    func getPreferencesListBy(request: GetPreferencesByIDRequest,completion: @escaping (_ result: PreferencesDetailResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: PreferencesDetailResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
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
