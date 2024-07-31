//
//  OffersNewpaperResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/11/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct OffersNewpaperResource{
    
    private let endPoint : String = "/offerNewspaper/list"
    
    func getDigitalNewspaperList(completion: @escaping (_ result: NewspaperResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: NewspaperResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
