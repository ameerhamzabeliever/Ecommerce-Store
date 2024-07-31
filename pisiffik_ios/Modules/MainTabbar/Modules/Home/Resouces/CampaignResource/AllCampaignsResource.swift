//
//  AllCampaignsResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct AllCampaignsResource{
    
    private var endPoint : String = "/campaign/all"
    
    func getAllCampaigns(completion: @escaping (_ result: AllCampaignsResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: AllCampaignsResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
