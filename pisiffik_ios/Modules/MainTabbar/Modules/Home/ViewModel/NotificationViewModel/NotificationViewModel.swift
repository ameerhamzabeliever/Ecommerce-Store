//
//  NotificationViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol NotificationViewModelDelegate : BaseProtocol {
    func didReceiveNotification(response: NotificationListResponse)
    func didReceiveNotificationResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct NotificationViewModel {
    
    var delegate : NotificationViewModelDelegate?
    let resource = NotificationListResource()
    
    func getNotificationList() {
        
        resource.getNotificationsResponse { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveNotificationResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveNotificationResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveNotification(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
