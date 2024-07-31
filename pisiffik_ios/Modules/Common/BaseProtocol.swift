//
//  BaseProtocol.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

protocol BaseProtocol{
    func didReceiveServer(error: [String]?,type: String,indexPath: Int)
    func didReceiveUnauthentic(error: [String]?)
}

extension BaseProtocol{
    func didReceiveServer(error: [String]?,type: String,indexPath: Int){}
    func didReceiveUnauthentic(error: [String]?) {}
}
