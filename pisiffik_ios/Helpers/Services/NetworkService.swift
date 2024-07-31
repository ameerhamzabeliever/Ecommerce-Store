//
//  NetworkService.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Localize_Swift

enum NetworkServiceError: Error{
    case invalidURL
    case networkError
    case responseError
    case decodingError
    case serverError
    case unknown
    case noResponseFound
}

extension String{
    static let GET : String = "GET"
    static let POST : String = "POST"
    static let KEY : String = "KEY"
    static let iOS : String = "iOS"
    static let KeyValue : String = "YW1Gb1lXNTZZV2xpTG1GemJHRnRMbTFsYUdGeVFHZHRZV2xzTG1OdmJUcHdhWE5wWm1scg=="
    static let ApplicationJson : String = "application/json"
    static let Accept : String = "Accept"
    static let ContentType : String = "Content-Type"
    static let XLocalization : String = "X-Localization"
    static let Authorization : String = "Authorization"
    static let Bearer : String = "Bearer"
}

struct NetworkManager {
    
    static let manager = Session(configuration: NetworkManager.configuration())
    
    static var baseURL: String {
        return ConfigurationManager.shared.getBackendUrlString()
    }
    
    static func configuration() -> URLSessionConfiguration {
        let staticHeaders = ["Accept": "application/json"]
        let configuration = Session.default.session.configuration
        configuration.timeoutIntervalForRequest = 30.0
        configuration.httpAdditionalHeaders = staticHeaders
        return configuration
    }
    
    static var authHeaders: HTTPHeaders {
        HTTPHeaders(["Authorization": "Bearer" + " " + (Constants.getAccessToken() ?? ""),
                     "Tag": UIDevice.current.identifierForVendor?.uuidString ?? "",
                     .KEY: .KeyValue,
                     .XLocalization: XCLocalization.shared.getLoc(),
                     "Cache-Control": "no-cache"])
    }
    
}

extension NetworkManager {
    
    static func getRequest<T: Codable>(endPoint: String, dataModel: T.Type ,completion: @escaping (_ results: T?,_ statusCode: Int?) -> Void) {
        manager.request(baseURL + endPoint,
                        method: .get,
                        parameters: nil,
                        headers: authHeaders)
        .validate()
        .responseDecodable(of: T.self) { response in
            
            self.printPrettyJSON(endPoint: endPoint, data: response.data)
            
            switch response.result {
            case .success(let model):
                completion(model,response.response?.statusCode)
            case .failure( _):
                
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    if let model = try? decoder.decode(T.self, from: responseData) {
                        completion(model,response.response?.statusCode)
                    }else{
                        completion(nil,response.response?.statusCode)
                    }
                }
            }
        }
        
    }
    
    static func postRequest<T: Codable>(endPoint: String, params: [String: Any]?, dataModel: T.Type ,completion: @escaping (_ results: T?,_ statusCode: Int?) -> Void) {
        manager.request(baseURL + endPoint,
                        method: .post,
                        parameters: params,
                        encoding: JSONEncoding.default,
                        headers: authHeaders).validate().responseDecodable(of: T.self) { response in
            
            self.printPrettyJSON(endPoint: endPoint, data: response.data)
            
            switch response.result {
            case .success(let model):
                completion(model,response.response?.statusCode)
            case .failure( _):
                
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    if let model = try? decoder.decode(T.self, from: responseData) {
                        completion(model,response.response?.statusCode)
                    }else{
                        completion(nil,response.response?.statusCode)
                    }
                }
            }
        }
    }
    
    static func postMultipartRequest<T: Codable>(endPoint: String,data: [Data]?,pdfData: [Data]?,params: [String: Any],dataModel: T.Type,completion: @escaping (_ result: T?,_ statusCode: Int?) -> Void){
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if value is Int {
                    multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if element is Int {
                            let value = "(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            
            if let data = data {
                if !data.isEmpty{
                    for index in (0...(data.count - 1)) {
                        multipartFormData.append(data[index], withName: "attachment[]", fileName: "attachment\(index).png", mimeType: "attachment/png")
                    }
                }
            }
            
            if let pdfData = pdfData {
                if !pdfData.isEmpty{
                    for index in (0...(pdfData.count - 1)){
                        multipartFormData.append(pdfData[index], withName: "attachment[]", fileName: "attachment\(index).pdf", mimeType: "attachment/pdf")
                    }
                }
            }
            
        }, to: baseURL + endPoint, method: .post, headers: authHeaders).validate().responseDecodable(of: T.self) { response in
            
            self.printPrettyJSON(endPoint: endPoint, data: response.data)
            
            switch response.result {
            case .success(let model):
                completion(model,response.response?.statusCode)
            case .failure( _):
                
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    if let model = try? decoder.decode(T.self, from: responseData) {
                        completion(model,response.response?.statusCode)
                    }else{
                        completion(nil,response.response?.statusCode)
                    }
                }
            }
            
        }
        
    }
    
    private static func printPrettyJSON(endPoint: String, data: Data?) {
        
        guard let data = data else {
            return
        }

        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            
            if let currentUser = DBUserManagerRepository().getUser() {
                print("\n\n*** ACCESS TOKKEN ***\n\n\(currentUser.token ?? "empty")\n")
            }
            print("*** API END POINT ***\n\(endPoint)\n")
            print("================ RESPONSE START ================ \n\(String(describing: json))\n================ RESPONSE END ================\n")
        } catch {
            print("Something went wrong")
        }
    }
}

final class XCLocalization{
    
    private init() {}
    
    static let shared = XCLocalization()
    
    func getLoc() -> String{
        if Localize.currentLanguage() == .danish{
            return .danish
        }else if Localize.currentLanguage() == .greenland{
            return .danishGL
        }else{
            return .english
        }
    }
    
}


