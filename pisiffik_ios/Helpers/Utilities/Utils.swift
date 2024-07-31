//
//  Utils.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit

final class Utils{
    
    static let shared = Utils()
    
    //UTC Formate Date....
    
    func getUTCFormate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    func getShoppingList(count: Int) -> String{
        if count > 0{
            if count > 9{
                return "9+"
            }else{
                return "\(count)"
            }
        }else{
            return  ""
        }
    }
    
    func goToAndEnableLocation(){
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func goToAndEnableCameraPermission(){
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func addNewShoppingListCounter(count : Int) -> String{
        let currentCounter = UserDefault.shared.getShoppingListCount()
        let newCounter = currentCounter + count
        UserDefault.shared.saveShoppingList(count: newCounter)
        let updatedCounter = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        return updatedCounter
    }
    
    func removeNewShoppingListCounter(count : Int) -> String{
        let currentCounter = UserDefault.shared.getShoppingListCount()
        let newCounter = currentCounter - count
        if newCounter >= 0{
            UserDefault.shared.saveShoppingList(count: newCounter)
        }else{
            UserDefault.shared.saveShoppingList(count: 0)
        }
        let updatedCounter = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        return updatedCounter
    }
    
    func convertBase64StringToImage(imageBase64String: String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData ?? Data())
        return image ?? UIImage()
    }
    
    func getDateObjForString(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        if let dateObj = dateFormatter.date(from: date){
            return dateObj
        }
        return Date()
    }
    
}
