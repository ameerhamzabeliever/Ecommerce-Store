//
//  FindNearbyStoresViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol FindNearbyStoresViewModelDelegate: BaseProtocol {
    
    func didReceiveNearbyStores(response: FindNearbyStoreResponse)
    func didReceiveNearbyStoresResponseWith(errorMessage: [String]?,statusCode: Int?)

}

class FindNearbyStoresViewModel {
    
    var delegate: FindNearbyStoresViewModelDelegate?
    
    func getNearbyStoresBy(request: FindNearbyStoreRequest){
        
        let resource = FindNearbyStoreResource()
        
        resource.getNearbyStores(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveNearbyStoresResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveNearbyStoresResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveNearbyStores(response: result)
                    }
                    
                }
                
            }
        }
        
    }
    
}
