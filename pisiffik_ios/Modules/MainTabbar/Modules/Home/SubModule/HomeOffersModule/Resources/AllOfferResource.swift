//
//  AllOfferResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct AllOffersResource{
    
    private var endPoint : String = "/currentOffer/all"
    
    func getAllOffersWith(request: AllOffersRequest,completion: @escaping (_ result: AllOffersResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint,params: param, dataModel: AllOffersResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
