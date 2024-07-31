//
//  CityResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct CityResource{
    
    private let endPoint : String = "/getCities"
    
    func getStates(request: CityRequest,completion : @escaping (_ result: CityResponse?,_ statusCode: Int?) -> Void) {
        do{
            let request = try request.asDictionary()
            NetworkManager.postRequest(endPoint: endPoint, params: request, dataModel: CityResponse.self) { results, statusCode in
                completion(results,statusCode)
            }
        }catch let error{
            debugPrint(error.localizedDescription)
        }

    }
    
}
