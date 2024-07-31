//
//  SplashViewModel.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

enum SplashNavigationType{
    case languageVC
    case loginVC
    case homeVC
}

class SplashViewModel{
    
    func loadViewController() -> SplashNavigationType{
        
        let user = DBUserManagerRepository().getUser()
        
        if let user = user {
            if ((user.id != nil) && (user.phoneVerify == 1) && (user.emailVerify == 1)){
                return .homeVC
            }else{
                return .loginVC
            }
        }else{
            return .languageVC
        }
        
    }
    
    
}
