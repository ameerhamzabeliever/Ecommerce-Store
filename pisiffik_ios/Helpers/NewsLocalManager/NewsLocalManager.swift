//
//  NewsLocalManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 03/10/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

final class NewsLocalManager{
    
    private init() {}
    
    static let shared = NewsLocalManager()
    
    func saveNewsID(id: Int){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getNewsID()
        if !arrayOfIDs.isEmpty{
            if arrayOfIDs.count >= 100{
                arrayOfIDs.removeLast()
            }
        }
        if !arrayOfIDs.contains(where: {$0 == id}){
            arrayOfIDs.insert(id, at: 0)
            userDefault.set(arrayOfIDs, forKey: "NewsID")
        }
    }
    
    func deleteAllNewsID(){
        let userDefault = UserDefaults.standard
        var arrayOfIDs = getNewsID()
        if !arrayOfIDs.isEmpty{
            arrayOfIDs.removeAll()
        }
        userDefault.set(arrayOfIDs, forKey: "NewsID")
    }
    
    func getNewsID() -> [Int]{
        let userDefault = UserDefaults.standard
        if let arrayOfID = userDefault.value(forKey: "NewsID") as? [Int]{
            return arrayOfID
        }
        return []
    }
    
}
