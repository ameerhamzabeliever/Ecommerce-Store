//
//  CDUser+CoreDataProperties.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 09/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var address: String?
    @NSManaged public var cityID: Int32
    @NSManaged public var cityName: String?
    @NSManaged public var countryID: Int32
    @NSManaged public var countryName: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var deletedAt: String?
    @NSManaged public var deviceType: String?
    @NSManaged public var dob: String?
    @NSManaged public var email: String?
    @NSManaged public var emailVerifiedAt: String?
    @NSManaged public var fcmToken: String?
    @NSManaged public var fullName: String?
    @NSManaged public var genderID: Int32
    @NSManaged public var genderName: String?
    @NSManaged public var id: String?
    @NSManaged public var isVerified: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var otp: Int32
    @NSManaged public var phone: String?
    @NSManaged public var rememberToken: String?
    @NSManaged public var stateID: Int32
    @NSManaged public var stateName: String?
    @NSManaged public var token: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var phoneVerify: Int32
    @NSManaged public var emailVerify: Int32

}

extension CDUser : Identifiable {

}
