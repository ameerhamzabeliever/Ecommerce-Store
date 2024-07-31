//
//  RemoveProductViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol RemoveProductViewModelDelegate : BaseProtocol {
    
    func didReceiveRemoveProduct(response: RemoveProductResponse,at indexPath: Int)
    func didReceiveRemoveProductResponseWith(errorMessage: [String]?,statusCode: Int?)

}

struct RemoveProductViewModel {
    
    var delegate : RemoveProductViewModelDelegate?
    private let resource = RemoveProductResource()
    
    func removeProductOf(variantID: Int,at indexPath: Int) {
        
       let request = RemoveProductRequest(variantID: variantID)
        
        resource.removeProductWith(request: request) { result, status in
            
            DispatchQueue.main.async {
                
                guard let statusCode = status else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.removeProductAPI,indexPath: indexPath)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveRemoveProductResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveRemoveProductResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveRemoveProduct(response: result, at: indexPath)
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
}
