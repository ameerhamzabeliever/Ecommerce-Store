//
//  AllCampaignsViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol AllCampaignsViewModelDelegate: BaseProtocol {
    func didReceiveAllCampaigns(response: AllCampaignsResponse)
    func didReceiveAllCampaignsResponseWith(errorMessage: [String]?,statusCode: Int?)
}

class AllCampaignsViewModel {
    
    var delegate: AllCampaignsViewModelDelegate?
    
    func getAllCampaigns(){
        
        let resource = AllCampaignsResource()
        
        resource.getAllCampaigns { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveAllCampaignsResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveAllCampaignsResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAllCampaigns(response: result)
                    }
                    
                }
                
            }
        }
        
    }
    
}
