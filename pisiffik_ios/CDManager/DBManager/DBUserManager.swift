//
//  DBUserManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import CoreData

struct User{
    let name : String
}

protocol DBUserRepository: DBBaseRepository {
    func getUser() -> UserData?
}

struct DBUserManagerRepository : DBUserRepository {
    
    typealias T = UserData
    
    func create(record: UserData) {
        self.deleteAllRecord()
        let cdUser = CDUser(context: PersistenceStorage.shared.context)
        _ = self.convert(user: record, To: cdUser)
        PersistenceStorage.shared.saveContext()
        
    }

    func getAll() -> [UserData]? {

        let result = PersistenceStorage.shared.fetchResultOf(type: CDUser.self)

        var users : [UserData] = []

        result?.forEach({ (cdUser) in
            users.append(self.get(user: cdUser))
        })

        return users
    }
    
    func getUser() -> UserData? {
        if let result = PersistenceStorage.shared.fetchResultOf(type: CDUser.self){
            if let user = result.first{
                return self.get(user: user)
            }
            return nil
        }
        return nil
    }

    func update(record: UserData) -> Bool {
        // update code here
        let result = self.getCDUser(byIdentifier: record.id ?? "")
        guard let result = result else { return false }
        
        _ = self.convert(user: record, To: result)
        PersistenceStorage.shared.saveContext()
        return true
    }
    
    func delete(record: UserData) -> Bool {
        
        let result = self.getCDUser(byIdentifier: record.id ?? "")
        guard let result = result else { return false }
        
        PersistenceStorage.shared.context.delete(result)
        PersistenceStorage.shared.saveContext()
        
        return true
    }
    
    func deleteAllRecord() {
        let result = PersistenceStorage.shared.fetchResultOf(type: CDUser.self)
        if let users = result{
            users.forEach { user in
                PersistenceStorage.shared.context.delete(user)
                PersistenceStorage.shared.saveContext()
            }
        }
    }

    
}



//MARK: - EXTENSION FOR PRIVATE METHODS -

extension DBUserManagerRepository{
    
    
    private func getCDUser(byIdentifier id: String) -> CDUser?{
        
        let fetchRequest = NSFetchRequest<CDUser>(entityName: "CDUser")
        let predicate = NSPredicate(format: "id==%@", id as String)
        fetchRequest.predicate = predicate
        
        do{
            let result = try PersistenceStorage.shared.context.fetch(fetchRequest).first
            guard let result = result else {return nil}
            return result
            
        }catch let error{
            debugPrint(error.localizedDescription)
            return nil
        }

    }
    
    private func get(user: CDUser) -> UserData{
        return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: user.email, fcmToken: user.fcmToken, emailVerifiedAt: user.emailVerifiedAt, dob: user.dob, country: Description(id: Int(user.countryID), name: user.countryName), gender: Description(id: Int(user.genderID), name: user.genderName), state: Description(id: Int(user.stateID), name: user.stateName), city: Description(id: Int(user.cityID), name: user.cityName), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: Int(user.otp), isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: user.token,phoneVerify: Int(user.phoneVerify),emailVerify: Int(user.emailVerify))
    }
    
    
    private func convert(user: UserData, To cdUser: CDUser) -> CDUser{
        cdUser.id = user.id
        cdUser.fullName = user.fullName
        cdUser.phone = user.phone
        cdUser.email = user.email
        cdUser.fcmToken = user.fcmToken
        cdUser.emailVerifiedAt = user.emailVerifiedAt
        cdUser.dob = user.dob
        cdUser.countryID = Int32(user.country?.id ?? 0)
        cdUser.countryName = user.country?.name
        cdUser.genderID = Int32(user.gender?.id ?? 0)
        cdUser.genderName = user.gender?.name
        cdUser.stateID = Int32(user.state?.id ?? 0)
        cdUser.stateName = user.state?.name
        cdUser.cityID = Int32(user.city?.id ?? 0)
        cdUser.cityName = user.city?.name
        cdUser.address = user.address
        cdUser.deviceType = user.deviceType
        cdUser.latitude = user.latitude ?? 0.0
        cdUser.longitude = user.longitude ?? 0.0
        cdUser.otp = Int32(user.otp ?? 0)
        cdUser.isVerified = user.isVerified ?? false
        cdUser.rememberToken = user.rememberToken
        cdUser.deletedAt = user.deletedAt
        cdUser.createdAt = user.createdAt
        cdUser.updatedAt = user.updatedAt
        cdUser.token = user.token
        cdUser.phoneVerify = Int32(user.phoneVerify ?? 0)
        cdUser.emailVerify = Int32(user.emailVerify ?? 0)
        return cdUser
    }
    
}
