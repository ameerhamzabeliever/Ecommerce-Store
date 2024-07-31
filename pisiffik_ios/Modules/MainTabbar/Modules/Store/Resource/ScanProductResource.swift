//
//  ScanProductResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct ScanProductResource {
    
    private let endPoint : String = "/product/detail/barcode"
    
    func getScanProductInfo(request: ScanProductRequest,completion: @escaping (_ result: ScanProductResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: endPoint, params: param, dataModel: ScanProductResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error {
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }

        
    }
    
}
