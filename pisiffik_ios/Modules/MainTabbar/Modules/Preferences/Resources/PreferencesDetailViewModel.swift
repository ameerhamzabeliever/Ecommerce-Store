//
//  PreferencesDetailViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol PreferencesDetailViewModelDelegate : BaseProtocol {
    func didReceivePreferencesDetail(response: PreferencesDetailResponse)
    func didReceivePreferencesDetailResponseWith(errorMessage: [String]?,statusCode: Int?)
    func didReceiveUpdatePreferences(response: UpdatePreferencesResponse)
    func didReceiveUpdatePreferencesResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct PreferencesDetailViewModel {
    
    var delegate : PreferencesDetailViewModelDelegate?
    let resource = PreferencesDetailResource()
    
    func getPreferencesDetailListBy(request: GetPreferencesByIDRequest) {
        
        resource.getPreferencesListBy(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceivePreferencesDetailResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceivePreferencesDetailResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceivePreferencesDetail(response: result)
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
