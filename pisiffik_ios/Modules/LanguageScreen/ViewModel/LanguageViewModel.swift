//
//  LanguageViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation


enum LanguageSelection{
    case dansk
    case greenland
    case english
}

enum LanguageMode{
    case fromSignUp
    case fromMyProfile
}


extension String{
    static let english : String = "en"
    static let danish : String = "da"
    static let greenland : String = "da-GL"
    static let danishGL : String = "gl"
}
