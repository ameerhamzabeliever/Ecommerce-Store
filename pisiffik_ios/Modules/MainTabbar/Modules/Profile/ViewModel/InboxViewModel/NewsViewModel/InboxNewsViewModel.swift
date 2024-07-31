//
//  InboxNewsViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol InboxNewsViewModelDelegate : BaseProtocol {
    func didReceiveNewsList(response: NewsListResponse)
    func didReceiveNewsListResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct InboxNewsViewModel {
    
    private let resource = InboxNewsResource()
    var delegate : InboxNewsViewModelDelegate?
    
    func getInboxNewsList(currentPage: Int) {
        
        resource.getNewsList(currentPage: currentPage) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveNewsListResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveNewsListResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveNewsList(response: result)
                    }
                    
                }
                
            }
            
        }
          
    }
    
    
    
}
