//
//  OfferEventsResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct OfferEventsResource{
    
    private let endPoint : String = "/offers"
    
    func getOffersData(completion: @escaping (_ result: OfferEventsBaseResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: OfferEventsBaseResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
