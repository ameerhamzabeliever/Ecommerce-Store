//
//  OtherFavoriteItemViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 31/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol OtherFavoriteItemViewModelDelegate : BaseProtocol {
    func didReceiveOtherFavoriteItemList(response: OtherFavoriteItemResponse)
    func didReceiveOtherFavoriteItemListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct OtherFavoriteItemViewModel {
    
    private let resource = OtherFavoriteItemResource()
    var delegate : OtherFavoriteItemViewModelDelegate?
    
    func getOtherFavoriteItemList() {
        
        resource.getPisiffikFavoriteList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveOtherFavoriteItemListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveOtherFavoriteItemListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveOtherFavoriteItemList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
