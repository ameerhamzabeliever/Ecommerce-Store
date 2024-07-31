//
//  AddTicketViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AddTicketViewModelDelegate : BaseProtocol {
    func didReceiveAddTicket(response: AddTicketResponse)
    func didReceiveAddTicketListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct AddTicketViewModel {
    
    private let resource = AddTicketResource()
    var delegate : AddTicketViewModelDelegate?
    
    func addNewTicket(request: AddTicketRequest,attachment: [Data]?,pdfData: [Data]?){
        
        let validation = AddTicketValidation().Validate(request: request)
        
        if validation.success{
            
            resource.addNewTicket(request: request, attachmentData: attachment,pdfData: pdfData) { result, statusCode in
                
                DispatchQueue.main.async {
                    
                    guard let statusCode = statusCode else { return }
                    
                    switch statusCode{
                        
                    case 401:
                        self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                        
                    case 500...599:
                        self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                        
                    default:
                        
                        guard let result = result else {
                            self.delegate?.didReceiveAddTicketListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                            return
                        }
                        
                        if result.error != nil{
                            self.delegate?.didReceiveAddTicketListResponseWith(errorMessage: result.error, statusCode: statusCode)
                        }else{
                            self.delegate?.didReceiveAddTicket(response: result)
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            self.delegate?.didReceiveAddTicketListResponseWith(errorMessage: [validation.error ?? ""], statusCode: nil)
        }
        
    }
         
         
    
}
