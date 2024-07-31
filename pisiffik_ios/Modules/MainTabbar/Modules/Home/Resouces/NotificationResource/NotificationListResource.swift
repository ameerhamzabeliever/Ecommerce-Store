//
//  NotificationListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct NotificationListResource {
    
    private let endPoint : String = "/notifications/list"
    
    func getNotificationsResponse(completion: @escaping (_ result: NotificationListResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: NotificationListResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }
    
}
