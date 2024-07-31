//
//  FaqListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct FaqListResource{
    
    private let endPoint : String = "/faq/type/list"
    
    func getFaqList(completion : @escaping (_ result: FaqListResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: FaqListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
