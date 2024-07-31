//
//  MyProfileViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol MyProfileViewModelDelegate : BaseProtocol {
    func didReceiveUpdateProfile(response: UpdateProfileResponse)
    func didReceiveUpdateProfileResponseWith(errorMessage: [String]?,statusCode: Int?)
}

struct MyProfileViewModel {
    
    private let validate = UpdateProfileValidation()
    private let resource = MyProfileResource()
    var delegate : MyProfileViewModelDelegate?
    
    func updateProfileWith(name: String,dob: String,genderID: Int,email: String?) {
        
        let request = UpdateProfileRequest(full_name: name, dob: dob, gender_id: genderID, email: email)
        
        let validation = validate.Validate(request: request)
        
        if (validation.success){
            
            resource.updateProfile(request: request) { result, statusCode in
                
                DispatchQueue.main.async {
                    
                    guard let statusCode = statusCode else { return }
                    
                    switch statusCode{
                        
                    case 401:
                        self.delegate?.didReceiveUnauthentic(error: [PisiffikStrings.sessionExpired()])
                        
                    case 500...599:
                        self.delegate?.didReceiveServer(error: [PisiffikStrings.somethingWentWron()],type: APIType.homeAPI,indexPath: 0)
                        
                    default:
                        
                        guard let result = result else {
                            self.delegate?.didReceiveUpdateProfileResponseWith(errorMessage: [PisiffikStrings.somethingWentWron()], statusCode: statusCode)
                            return
                        }
                        
                        if result.error != nil{
                            self.delegate?.didReceiveUpdateProfileResponseWith(errorMessage: result.error, statusCode: statusCode)
                        }else{
                            self.delegate?.didReceiveUpdateProfile(response: result)
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            self.delegate?.didReceiveUpdateProfileResponseWith(errorMessage: [validation.error ?? ""], statusCode: nil)
        }
        
    }
    
    
    
}
