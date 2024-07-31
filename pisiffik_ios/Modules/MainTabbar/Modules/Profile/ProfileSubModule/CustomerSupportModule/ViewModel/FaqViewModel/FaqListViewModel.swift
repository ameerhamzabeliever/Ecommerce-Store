//
//  FaqListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol FaqListViewModelDelegate : BaseProtocol {
    func didReceiveFaqList(response: FaqListResponse)
    func didReceiveFaqListResponseWithWith(errorMessage: [String]?,statusCode: Int?)
}

struct FaqListViewModel {
    
    private let resource = FaqListResource()
    var delegate : FaqListViewModelDelegate?
    
    func getFaqList(){
        
        resource.getFaqList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveFaqListResponseWithWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveFaqListResponseWithWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveFaqList(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
