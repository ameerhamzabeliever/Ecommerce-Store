//
//  AddressListResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddressListResource{
    
    private let getListEndPoint : String = "/address/list"
    private let deleteListEndPoints : String = "/address/delete"
    
    func getAddressList(completion : @escaping (_ result: AddressListResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: getListEndPoint, dataModel: AddressListResponse.self) { results, statusCode in
            completion(results,statusCode)
        }
        
    }

    
    func deleteAddress(request: DeleteAddressRequest, completion : @escaping (_ result: BaseResponse?,_ statusCode: Int?) -> Void) {
        do {
            
            let param = try request.asDictionary()
            
            NetworkManager.postRequest(endPoint: deleteListEndPoints, params: param, dataModel: BaseResponse.self) { results, statusCode in
                
               completion(results,statusCode)
                
            }
        }
        catch let error {
            debugPrint(error)
            completion(nil,nil)
        }
        
    }
    
    
}
