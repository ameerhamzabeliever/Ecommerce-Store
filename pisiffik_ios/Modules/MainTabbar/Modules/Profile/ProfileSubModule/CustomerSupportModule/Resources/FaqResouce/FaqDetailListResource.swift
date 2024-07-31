//
//  FaqDetailListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct FaqDetailListResource{
    
    private let endPoint : String = "/faq/list/"
    
    func getFaqsBy(id: Int,completion : @escaping (_ result: FaqDetailListResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint + "\(id)", dataModel: FaqDetailListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
