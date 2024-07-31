//
//  FaqDetailListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol FaqDetailListViewModelDelegate : BaseProtocol {
    func didReceiveFaqs(response: FaqDetailListResponse)
    func didReceiveFaqResponseWithWith(errorMessage: [String]?,statusCode: Int?)
}

struct FaqDetailListViewModel {
    
    private let resource = FaqDetailListResource()
    var delegate : FaqDetailListViewModelDelegate?
    
    func getFaqsBy(id: Int){
        
        resource.getFaqsBy(id: id) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveFaqResponseWithWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveFaqResponseWithWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveFaqs(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
