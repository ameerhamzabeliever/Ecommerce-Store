//
//  InboxEventDetailResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

import Foundation

struct InboxEventDetailResource{
    
    private let endPoint : String = "/event/detail"
    
    func getEventDetail(with request: EventDetailRequest,completion : @escaping (_ result: EventDetailResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            let params = try request.asDictionary()
            NetworkManager.postRequest(endPoint: endPoint, params: params, dataModel: EventDetailResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch{
            Constants.printLogs(error.localizedDescription)
            completion(nil,nil)
        }
        
    }
    
}
