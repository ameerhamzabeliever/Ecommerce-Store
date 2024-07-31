//
//  TicketDetailViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol TicketDetailViewModelDelegate : BaseProtocol {
    func didReceiveTicketMessages(response: TicketDetailResponse)
    func didReceiveTicketMessagesResponseWith(errorMessage: [String]?,statusCode: Int?)
    func didReceiveTicketSendMessage(response: TicketMessageResponse)
    func didReceiveTicketSendMessageResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct TicketDetailViewModel {
    
    private let resource = InboxTicketResource()
    var delegate : TicketDetailViewModelDelegate?
    
    func getTicketMessageBy(id: Int){
        
        let request = TicketDetailRequest(ticketID: id)
        
        resource.getTicketMessages(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveTicketMessagesResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveTicketMessagesResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveTicketMessages(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func didSendTicket(message: String,ticketID: String,attachmentData: [Data]?,pdfData: [Data]?){
        
        let request = TicketMessageRequest(ticketID: ticketID, message: message)
        
        resource.sendTicketMessage(request: request, attachmentData: attachmentData, pdfData: pdfData) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveTicketSendMessageResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveTicketSendMessageResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveTicketSendMessage(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
}
