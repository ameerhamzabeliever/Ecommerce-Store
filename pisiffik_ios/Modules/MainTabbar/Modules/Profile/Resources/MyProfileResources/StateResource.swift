//
//  StateResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct StateResource{
    
    private let endPoint : String = "/getStates"
    
    func getStates(request: StateRequest,completion : @escaping (_ result: StateResponse?,_ statusCode: Int?) -> Void) {
        do{
            let request = try request.asDictionary()
            NetworkManager.postRequest(endPoint: endPoint, params: request, dataModel: StateResponse.self) { results, statusCode in
                completion(results,statusCode)
            }
        }catch let error{
            debugPrint(error.localizedDescription)
        }

    }
    
}
