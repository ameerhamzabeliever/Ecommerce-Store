//
//  UserDefaultManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct UserDefault{
    
    private init() {}
    
    static let shared = UserDefault()
    
    func saveAccessTokenForResetPassword(token: String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token, forKey: "accessToken")
    }
    
    func getAccessTokenForResetPassword() -> String{
        let defaults = UserDefaults.standard
        if let token = defaults.value(forKey: "accessToken") as? String{
            return token
        }
        return ""
    }
    
    func saveUserCurrent(points: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(points, forKey: "userCurrentPoints")
    }
    
    func getUserCurrentPoints() -> Int{
        let defaults = UserDefaults.standard
        if let points = defaults.value(forKey: "userCurrentPoints") as? Int{
            return points
        }
        return 0
    }
    
    func saveMedia(url: String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(url, forKey: "media_url")
    }
    
    func getMediaURL() -> String{
        let defaults = UserDefaults.standard
        if let token = defaults.value(forKey: "media_url") as? String{
            return token
        }
        return ""
    }
    
    func saveNotificationBadge(count: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(count, forKey: "NotificationBadgeCount")
    }
    
    func getNotificationBadgeCount() -> Int{
        let defaults = UserDefaults.standard
        if let count = defaults.value(forKey: "NotificationBadgeCount") as? Int{
            return count
        }
        return 0
    }
    
    func saveShoppingList(count: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(count, forKey: "ShoppingListCount")
    }
    
    func getShoppingListCount() -> Int{
        let defaults = UserDefaults.standard
        if let count = defaults.value(forKey: "ShoppingListCount") as? Int{
            return count
        }
        return 0
    }
    
    func saveCartList(count: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(count, forKey: "CartListCount")
    }
    
    func getCartListCount() -> Int{
        let defaults = UserDefaults.standard
        if let count = defaults.value(forKey: "CartListCount") as? Int{
            return count
        }
        return 0
    }
    
    func saveNotificationsID(id: Int){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getNotificationsID()
        if !arrayOfIDs.isEmpty{
            if arrayOfIDs.count >= 100{
                arrayOfIDs.removeLast()
            }
        }
        if !arrayOfIDs.contains(where: {$0 == id}){
            arrayOfIDs.insert(id, at: 0)
            userDefault.set(arrayOfIDs, forKey: "NotificationsID")
        }
    }
    
    func deleteAllNotificationsID(){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getNotificationsID()
        if !arrayOfIDs.isEmpty{
            arrayOfIDs.removeAll()
        }
        userDefault.set(arrayOfIDs, forKey: "NotificationsID")
    }
    
    func getNotificationsID() -> [Int]{
        let userDefault = UserDefaults.standard
        if let arrayOfID = userDefault.value(forKey: "NotificationsID") as? [Int]{
            return arrayOfID
        }
        return []
    }
    
    func saveNewsDetailVC(open: Bool){
        let userDefault = UserDefaults.standard
        userDefault.setValue(open, forKey: "saveNewsDetailScreenStatus")
    }
    
    func isNewsDetailVC() -> Bool{
        let userDefault = UserDefaults.standard
        if let isOpen = userDefault.value(forKey: "saveNewsDetailScreenStatus") as? Bool{
            return isOpen
        }
        return false
    }
    
    func saveEventDetailVC(open: Bool){
        let userDefault = UserDefaults.standard
        userDefault.setValue(open, forKey: "saveEventDetailScreenStatus")
    }
    
    func isEventDetailVC() -> Bool{
        let userDefault = UserDefaults.standard
        if let isOpen = userDefault.value(forKey: "saveEventDetailScreenStatus") as? Bool{
            return isOpen
        }
        return false
    }
    
    func saveRecipeDetailVC(open: Bool){
        let userDefault = UserDefaults.standard
        userDefault.setValue(open, forKey: "saveRecipeDetailScreenStatus")
    }
    
    func isRecipeDetailVC() -> Bool{
        let userDefault = UserDefaults.standard
        if let isOpen = userDefault.value(forKey: "saveRecipeDetailScreenStatus") as? Bool{
            return isOpen
        }
        return false
    }
    
    func saveTicketDetailVC(open: Bool){
        let userDefault = UserDefaults.standard
        userDefault.setValue(open, forKey: "saveTicketDetailScreenStatus")
    }
    
    func isTicketDetailVC() -> Bool{
        let userDefault = UserDefaults.standard
        if let isOpen = userDefault.value(forKey: "saveTicketDetailScreenStatus") as? Bool{
            return isOpen
        }
        return false
    }
    
}
