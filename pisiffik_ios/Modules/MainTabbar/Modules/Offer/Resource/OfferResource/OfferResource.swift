//
//  OfferResource.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 18/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

struct OfferResource{
    
    private let endPoint : String = "/offers/getOffers"
    
    func getOffersData(request: OfferRequest,completion: @escaping (_ result: OfferResponse?,_ statusCode: Int?) -> Void){
        do{
            let params = try request.asDictionary()
            NetworkManager.postRequest(endPoint: endPoint, params: params, dataModel: OfferResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
        }catch{
            completion(nil, nil)
        }
    }
    
}
