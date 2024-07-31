//
//  GenerateBarcodeResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct GenerateBarcodeResource {
    
    private let endPoint : String = "/customer/barcode/generate"
    
    func generateBarcode(completion: @escaping (_ result: GenerateBarcodeResponse?,_ statusCode: Int?) -> Void){
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: GenerateBarcodeResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }
    
}
