//
//  LogoutResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 12/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct LogoutResource{
    
    private let endPoint : String = "/customer/logout"
    
    func logoutUser(completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: endPoint, dataModel: BaseResponse.self) { results, statusCode in
            completion(results , statusCode)
        }

    }
    
}
