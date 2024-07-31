//
//  PreferencesListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol PreferencesListViewModelDelegate : BaseProtocol {
    func didReceivePreferencesList(response: PreferencesListResponse)
    func didReceivePreferencesListResponseWith(errorMessage: [String]?,statusCode: Int?)
    func didReceiveUpdatePreferences(response: UpdatePreferencesResponse)
    func didReceiveUpdatePreferencesResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct PreferencesListViewModel {
    
    var delegate : PreferencesListViewModelDelegate?
    let resource = PreferencesListResource()
    
    func getPreferencesList() {
        
        resource.getPreferencesList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceivePreferencesListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceivePreferencesListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceivePreferencesList(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
    func updatePreferences(request: UpdatePreferenceRequest){
        
        resource.updatePreferences(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveUpdatePreferencesResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveUpdatePreferencesResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveUpdatePreferences(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
