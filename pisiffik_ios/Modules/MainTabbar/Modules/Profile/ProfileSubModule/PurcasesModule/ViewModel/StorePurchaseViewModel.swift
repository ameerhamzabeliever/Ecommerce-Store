//
//  StorePurchaseViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol StorePurchaseViewModelDelegate : BaseProtocol {
    func didReceiveStorePurchase(response: StorePurchaseResponse)
    func didReceiveStorePurchaseWith(errorMessage: [String]?,statusCode: Int?)
}

struct StorePurchaseViewModel {
    
    private let resource = StorePurchaseResource()
    var delegate : StorePurchaseViewModelDelegate?
    
    func getStorePurchaseDetail(with id: Int,mode: StorePurchaseMode) {
        
        resource.getStorePurchaseDetail(with: id,mode: mode) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveStorePurchaseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveStorePurchaseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveStorePurchase(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
}
