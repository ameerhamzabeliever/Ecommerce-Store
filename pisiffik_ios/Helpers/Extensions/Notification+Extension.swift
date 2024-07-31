//
//  Notification+Extension.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import Localize_Swift

extension Notification.Name {
    
    static let languageChanged = Notification.Name(LCLLanguageChangeNotification)
    static let newsTab = Notification.Name("newsTab")
    static let eventsTab = Notification.Name("eventsTab")
    static let ticketsTab = Notification.Name("ticketsTab")
    static let personalTab = Notification.Name("personalTab")
    static let localTab = Notification.Name("localTab")
    static let membershipTab = Notification.Name("membershipTab")
    static let pisiffikFavoritesTab = Notification.Name("pisiffikFavoritesTab")
    static let otherFavoritesTab = Notification.Name("otherFavoritesTab")
    static let recipeFavoritesTab = Notification.Name("recipeFavoritesTab")
    static let recipeFavoriteListUpdate = Notification.Name("recipeFavoriteListUpdate")
    static let foodItemFavoriteListUpdate = Notification.Name("foodItemFavoriteListUpdate")
    static let myFavoritesShoppingListCounter = Notification.Name("myFavoritesShoppingListCounter")
    static let pushNotificationReceived = Notification.Name("pushNotificationReceived")
    static let updateHomeNotificationCount = Notification.Name("updateHomeNotificationCount")
    
}


//MARK: - EXTENSION FOR NOTIFICATION OBJECT KEYS -

extension String{
    
    static let foodItemID : String = "food_item_id"
    static let recipeID : String = "recipe_id"
    static let isFavorite : String = "is_favorite"
    static let counter : String = "counter"
    static let type : String = "type"
    static let title : String = "title"
    static let body : String = "body"
    static let data : String = "data"
    static let notificationID : String = "notificationID"
    static let home : String = "Home"
    static let UTCFormat : String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    static let LocalFormat : String = "yyyy-MM-dd HH:mm:ss"
}
