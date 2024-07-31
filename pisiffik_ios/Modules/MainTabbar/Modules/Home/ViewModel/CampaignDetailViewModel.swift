//
//  CampaignDetailViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 13/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol CampaignDetailViewModelDelegate: BaseProtocol {
    func didReceiveCampaignProducts(response: CampaignDetailResponse)
    func didReceiveCampaignProductsResponseWith(errorMessage: [String]?,statusCode: Int?)
}

class CampaignDetailViewModel {
    
    var delegate: CampaignDetailViewModelDelegate?
    
    func getCampaignsProducts(with request: CampaignDetailRequest){
        
        let resource = CampaignDetailResource()
        
        resource.getCampaignDetailWith(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveCampaignProductsResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveCampaignProductsResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveCampaignProducts(response: result)
                    }
                    
                }
                
            }
        }
        
    }
    
}
