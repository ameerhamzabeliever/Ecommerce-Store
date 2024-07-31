//
//  CampaignDetailResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct CampaignDetailResource{
    
    private var endPoint : String = "/campaign/detail"
    
    func getCampaignDetailWith(request: CampaignDetailRequest,completion: @escaping (_ result: CampaignDetailResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint,params: param, dataModel: CampaignDetailResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
