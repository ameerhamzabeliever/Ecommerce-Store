//
//  EventIDLocalManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/10/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

final class EventIDLocalManager{
    
    private init() {}
    
    static let shared = EventIDLocalManager()
    
    func saveEventID(id: Int){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getEventID()
        if !arrayOfIDs.isEmpty{
            if arrayOfIDs.count >= 100{
                arrayOfIDs.removeLast()
            }
        }
        if !arrayOfIDs.contains(where: {$0 == id}){
            arrayOfIDs.insert(id, at: 0)
            userDefault.set(arrayOfIDs, forKey: "EventID")
        }
    }
    
    func deleteAllEventID(){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getEventID()
        if !arrayOfIDs.isEmpty{
            arrayOfIDs.removeAll()
        }
        userDefault.set(arrayOfIDs, forKey: "EventID")
    }
    
    func getEventID() -> [Int]{
        let userDefault = UserDefaults.standard
        if let arrayOfID = userDefault.value(forKey: "EventID") as? [Int]{
            return arrayOfID
        }
        return []
    }
    
}
