//
//  EventDetailViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol EventDetailViewModelDelegate : BaseProtocol {
    func didReceiveEventDetail(response: EventDetailResponse)
    func didReceiveEventDetailResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct EventDetailViewModel {
    
    private let resource = InboxEventDetailResource()
    var delegate : EventDetailViewModelDelegate?
    
    func getInboxEventDetail(with request: EventDetailRequest) {
        
        resource.getEventDetail(with: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveEventDetailResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveEventDetailResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveEventDetail(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
