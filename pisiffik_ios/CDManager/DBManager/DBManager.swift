//
//  DBManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import CoreData

protocol DBBaseRepository{
    
    associatedtype T
    
    func create(record: T)
    func getAll() -> [T]?
    func update(record: T) -> Bool
    func delete(record: T) -> Bool
    func deleteAllRecord()
    
}


protocol DBRepository: DBBaseRepository {
    
}

struct DBManagerRepository : DBRepository{
   
    
    typealias T = User
    
    func create(record: User) {
        
    }

    func getAll() -> [User]? {
        return []
    }
    
    func update(record: User) -> Bool {
        return false
    }
    
    func delete(record: User) -> Bool {
        return false
    }
    
    func deleteAllRecord() {
        
    }

    
}

