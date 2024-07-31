//
//  InboxTicketResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct InboxTicketResource{
    
    private let listEndPoint : String = "/ticket/list"
    private let listDetailEndPoint : String = "/ticket/messages"
    private let sendMessageEndPoint : String = "/ticket/sendMessage"
    
    func getTicketList(completion : @escaping (_ result: TicketListResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: listEndPoint, dataModel: TicketListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
    func getTicketMessages(request: TicketDetailRequest,completion: @escaping (_ result: TicketDetailResponse?,_ statusCode: Int?) -> Void){
        
        do{
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: listDetailEndPoint, params: param, dataModel: TicketDetailResponse.self) { results, statusCode in
                completion(results, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
    
    func sendTicketMessage(request: TicketMessageRequest,attachmentData: [Data]?,pdfData: [Data]?,completion : @escaping (_ result: TicketMessageResponse?,_ statusCode: Int?) -> Void) {
        
        do{
            
            let params = try request.asDictionary()
            
            NetworkManager.postMultipartRequest(endPoint: sendMessageEndPoint, data: attachmentData,pdfData: pdfData, params: params, dataModel: TicketMessageResponse.self) { result, statusCode in
                completion(result, statusCode)
            }
            
        }catch let error{
            debugPrint(error.localizedDescription)
            completion(nil, nil)
        }
        
    }
    
}
