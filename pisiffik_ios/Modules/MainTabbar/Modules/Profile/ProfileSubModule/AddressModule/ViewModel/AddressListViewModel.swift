//
//  AddressListViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol AddressListViewModelDelegate : BaseProtocol {
    
    func didReceiveAddressList(response: AddressListResponse)
    func didReceiveDeleteAddress(response: BaseResponse)
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?)
    
}

struct AddressListViewModel {
    
    var delegate : AddressListViewModelDelegate?
    private let resource = AddressListResource()
    
    func getAddress(){
        
        resource.getAddressList { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveAddressList(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func deleteAddressFromListWith(id: Int){
        
        let request = DeleteAddressRequest(id: id)
        
        resource.deleteAddress(request: request) { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveDeleteAddress(response: result)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
}
