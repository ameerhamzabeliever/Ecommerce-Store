//
//  PisiffikItemDetailViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol PisiffikItemDetailViewModelDelegate: BaseProtocol {
    
    func didReceivePisiffikItemDetail(response: PisiffikItemDetailResponse)
    func didReceivePisiffikItemDetailResponseWith(errorMessage: [String]?,statusCode: Int?)

}

class PisiffikItemDetailViewModel {
    
    var delegate: PisiffikItemDetailViewModelDelegate?
    
    func getPisiffikItemDetailBy(request: PisiffikItemDetailRequest){
        
        let resource = PisiffikItemDetailResource()
        
        resource.getPisiffikItemDetailResponse(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceivePisiffikItemDetailResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceivePisiffikItemDetailResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceivePisiffikItemDetail(response: result)
                    }
                    
                }
                
            }
        }
        
    }
    
}
