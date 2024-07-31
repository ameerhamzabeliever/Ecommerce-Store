//
//  ScanProductViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol ScanProductViewModelDelegate : BaseProtocol {
    func didReceiveScanProductInfo(response: ScanProductResponse)
    func didReceiveScanProductInfoResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct ScanProductViewModel {
    
    var delegate : ScanProductViewModelDelegate?
    let resource = ScanProductResource()
    
    func getScanProductInfo(request: ScanProductRequest) {
        
        resource.getScanProductInfo(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveScanProductInfoResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveScanProductInfoResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveScanProductInfo(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
