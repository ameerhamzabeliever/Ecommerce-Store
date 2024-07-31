//
//  TicketReasonResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct TicketReasonResource{
    
    private let endPoint : String = "/ticket/reasons"
    
    func getReasons(completion : @escaping (_ result: TicketReasonResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: TicketReasonResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
