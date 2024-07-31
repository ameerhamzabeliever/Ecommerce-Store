//
//  MyPointsViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol MyPointsViewModelDelegate : BaseProtocol {
    func didReceiveMyPoints(response: MyPointsResponse)
    func didReceiveMyPointsResponseWith(errorMessage: [String]?,statusCode: Int?)
}

enum MyPointsEarnedType: String, CaseIterable{
    case redeem = "Redeem"
    case earned = "Earned"
    case all = "All"
}

enum MyPointsDurationType: String, CaseIterable{
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct MyPointsViewModel {
    
    private let resource = MyPointsResource()
    var delegate : MyPointsViewModelDelegate?
    
    func getMyPoints(with request: MyPointsRequest,currentPage: Int) {
        
        resource.getPoints(request: request,currentPage: currentPage) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveMyPointsResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveMyPointsResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveMyPoints(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
}
