//
//  InboxNewsResource.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct InboxNewsResource{
    
    private let newsListEndPoint : String = "/news?page="
    
    func getNewsList(currentPage: Int,completion : @escaping (_ result: NewsListResponse?,_ statusCode: Int?) -> Void) {
        
        NetworkManager.getRequest(endPoint: newsListEndPoint + "\(currentPage)", dataModel: NewsListResponse.self) { results, statusCode in
            completion(results, statusCode)
        }
        
    }
    
}
