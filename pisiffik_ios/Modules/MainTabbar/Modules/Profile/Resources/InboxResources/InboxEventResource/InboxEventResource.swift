//
//  InboxEventResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct InboxEventResource{
    
    private let endPoint : String = "/event/list?page="
    
    func getEventsList(currentPage: Int,completion : @escaping (_ result: EventsListResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: endPoint + "\(currentPage)", dataModel: EventsListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
