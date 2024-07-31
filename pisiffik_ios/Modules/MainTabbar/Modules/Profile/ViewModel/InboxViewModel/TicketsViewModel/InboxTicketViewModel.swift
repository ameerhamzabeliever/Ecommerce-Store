//
//  InboxTicketViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

enum InboxType{
    case news
    case events
    case tickets
}

protocol InboxTicketViewModelDelegate : BaseProtocol {
    func didReceiveTicketList(response: TicketListResponse)
    func didReceiveTicketListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct InboxTicketViewModel {
    
    private let resource = InboxTicketResource()
    var delegate : InboxTicketViewModelDelegate?
    
    func getInboxTicketList() {
        
        resource.getTicketList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveTicketListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveTicketListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveTicketList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
