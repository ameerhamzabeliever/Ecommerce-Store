//
//  GenerateBarcodeViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol GenerateBarcodeViewModelDelegate : BaseProtocol {
    func didReceiveGenerateBarcode(response: GenerateBarcodeResponse)
    func didReceiveGenerateBarcodeResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct GenerateBarcodeViewModel {
    
    var delegate : GenerateBarcodeViewModelDelegate?
    let resource = GenerateBarcodeResource()
    
    func generateBarcode() {
        
        resource.generateBarcode { result, statusCode in
            
            DispatchQueue.main.async {
                
                guard let statusCode = statusCode else { return }
                
                switch statusCode{
                    
                case 401:
                    self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                    
                case 500...599:
                    self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.generateBarcode,indexPath: 0)
                    
                default:
                    
                    guard let result = result else {
                        self.delegate?.didReceiveGenerateBarcodeResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                        return
                    }
                    
                    if result.error != nil{
                        self.delegate?.didReceiveGenerateBarcodeResponseWith(errorMessage: result.error, statusCode: statusCode)
                    }else{
                        self.delegate?.didReceiveGenerateBarcode(response: result)
                    }
                    
                }
                
            }
            
        }
    }
    
}
