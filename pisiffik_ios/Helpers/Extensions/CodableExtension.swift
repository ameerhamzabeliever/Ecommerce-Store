//
//  CodableExtension.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 21/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
    
    func asJSON() throws -> String{
        let data = try JSONEncoder().encode(self)
        guard let string = String(data: data, encoding: .utf8) else {throw NSError()}
        return string
    }
    
}
