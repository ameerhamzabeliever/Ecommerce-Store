//
//  EmailVerifyViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/10/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol EmailVerifyViewModelDelegate : BaseProtocol {
    func didReceiveVerifyEmail(response: BaseResponse)
    func didReceiveVerifyEmailResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct EmailVerifyViewModel {
    
    private let validate = VerifyEmailValidation()
    private let resource = EmailVerifyResource()
    var delegate : EmailVerifyViewModelDelegate?
    
    func verifyEmail(with request: EmailVerifyRequest) {
        
        let validation = validate.Validate(request: request)
        
        if (validation.success){
            
            resource.verifyEmail(request: request) { result, statusCode in
                
                DispatchQueue.main.async {
                    
                    guard let statusCode = statusCode else { return }
                    
                    switch statusCode{
                        
                    case 401:
                        self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                        
                    case 500...599:
                        self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                        
                    default:
                        
                        guard let result = result else {
                            self.delegate?.didReceiveVerifyEmailResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                            return
                        }
                        
                        if result.error != nil{
                            self.delegate?.didReceiveVerifyEmailResponseWith(errorMessage: result.error, statusCode: statusCode)
                        }else{
                            self.delegate?.didReceiveVerifyEmail(response: result)
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            self.delegate?.didReceiveVerifyEmailResponseWith(errorMessage: [validation.error ?? ""], statusCode: nil)
        }
        
    }
    
    
    
}
