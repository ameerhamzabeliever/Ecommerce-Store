//
//  AddTicketResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddTicketResource{
    
    private let endPoint : String = "/ticket/create"
    
    func addNewTicket(request: AddTicketRequest,attachmentData: [Data]?,pdfData: [Data]?,completion : @escaping (_ result: AddTicketResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            
            let params = try request.asDictionary()
            
            NetworkManager.postMultipartRequest(endPoint: endPoint, data: attachmentData,pdfData: pdfData, params: params, dataModel: AddTicketResponse.self) { result, statusCode in
                completion(result, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
