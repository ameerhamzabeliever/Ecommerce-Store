//
//  HomeResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct HomeResource {
    
    private let homeEndPoint : String = "/home"
    
    func getHomeResponse(completion: @escaping (_ result: HomeResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: homeEndPoint, dataModel: HomeResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }
    
}
