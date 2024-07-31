//
//  RemovePreferenceViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RemovePreferenceViewModelDelegate : BaseProtocol {
    func didReceiveRemovePreference(response: BaseResponse)
    func didReceiveRemovePreferenceResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct RemovePreferenceViewModel {
    
    var delegate : RemovePreferenceViewModelDelegate?
    let resource = RemovePreferenceResource()
    
    func removePreferenceBy(request: RemoveCategoryRequest) {
        
        resource.removePreferenceBy(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveRemovePreferenceResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveRemovePreferenceResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveRemovePreference(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
