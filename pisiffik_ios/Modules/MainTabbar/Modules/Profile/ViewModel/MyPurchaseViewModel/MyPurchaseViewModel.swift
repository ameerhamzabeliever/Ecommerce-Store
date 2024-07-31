//
//  MyPurchaseViewModel.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 21/07/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import Foundation

protocol MyPurchaseViewModelDelegate : BaseProtocol {
    func didReceiveMyPurchase(response: MyPurchaseResponse)
    func didReceiveMyPurchaseResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct MyPurchaseViewModel {
    
    private let resource = MyPurchaseResource()
    var delegate : MyPurchaseViewModelDelegate?
    
    func getMyPurchases(with request: MyPurchaseRequest) {
        
        resource.getPurchaseList(with: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveMyPurchaseResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveMyPurchaseResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveMyPurchase(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func getFilters() -> [String]{
        var arrayOfFilters: [String] = ["Month"]
        if var currentYear = Calendar.current.dateComponents([.year], from: Date()).year{
            arrayOfFilters.append("\(currentYear)")
            for _ in 0...3{
                currentYear -= 1
                arrayOfFilters.append("\(currentYear)")
            }
        }
        return arrayOfFilters
    }
    
}
