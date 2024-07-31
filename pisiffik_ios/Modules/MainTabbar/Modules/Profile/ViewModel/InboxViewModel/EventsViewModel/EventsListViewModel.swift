//
//  EventsListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol EventsListViewModelDelegate : BaseProtocol {
    func didReceiveEventsList(response: EventsListResponse)
    func didReceiveEventsListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct EventsListViewModel {
    
    private let resource = InboxEventResource()
    var delegate : EventsListViewModelDelegate?
    
    func getInboxEventsList(currentPage: Int) {
        
        resource.getEventsList(currentPage: currentPage) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveEventsListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveEventsListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveEventsList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
