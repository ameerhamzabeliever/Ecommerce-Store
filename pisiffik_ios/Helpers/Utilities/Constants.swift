//
//  Constants.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView

typealias ListViewMethods = UITableViewDelegate & UITableViewDataSource
typealias CollectionViewMethods = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
typealias FSPagerViewMethods = FSPagerViewDelegate & FSPagerViewDataSource

struct Constants{
    
    static var baseURL: String{
        return ConfigurationManager.shared.getBackendUrlString()
    }
    
    static func printLogs(_ string: String){
        print(string)
    }
    
    static var fcmToken: String{
        return (UIApplication.shared.delegate as! AppDelegate).fcm_Tokken
    }
    
    static var APIKey: String{
        return ""
    }
    
    static var GDPR: String{
        return "https://crm.dev.pisiffik.gl/legal/gdpr/"
    }
    
    static var AppStoreLink: String{
        return "http://apps.apple.com/app/pisiffik_ios/id1637092101"
    }
    
    static var maxLoyalityPoints: Int{
        return 500000
    }
    
    static var maxDiscountInCurrency: Int{
        return 500
    }
    
    static func getAccessToken() -> String?{
        if let user = DBUserManagerRepository().getUser(){
            if let token = user.token{
                return token
            }else{
                return UserDefault.shared.getAccessTokenForResetPassword()
            }
        }else{
            return UserDefault.shared.getAccessTokenForResetPassword()
        }
    }
    
    
}
