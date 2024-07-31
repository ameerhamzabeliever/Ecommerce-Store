//
//  CountryResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct CountryResource{
    
    private let endPoint : String = "/getCountries"
    
    func getCountries(completion : @escaping (_ result: CountryResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: CountryResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }
    
}
