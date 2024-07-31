//
//  PushManager.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 19/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit

struct PushManager {
    
    static let router = RootRouter()
    
    static private func markNotificationAsSeen(notificationId: String) {
       /* ConnectionManager.markNotificationAsSeen(notificationId, completion: { response in
            switch response.result {
            case .success(let user):
                UserManager.currentUser = user
            case .failure:
                break
            }
        }) */
    }
    
    static private func openMail(payload: [AnyHashable: Any], changeTabTo idx: Int) {
        /* guard let mailId = payload["mail_id"] as? String, !mailId.isEmpty else {
            //Mail id was not present, so lets open the notification tab instead
            _ = RouterManager.changeSelectedTabTo(index: idx)
            return
        }
        RouterManager.openMail(id: mailId, animated: false) */
    }
    
    static func handlePush(_ payload: [AnyHashable: Any], appWasActive: Bool) {
        guard let type = payload["event"] as? String,
              let aps = payload["aps"] as? [String: Any],
              let alert = aps["alert"] as? [String: Any],
              let title = alert["title"] as? String,
              let body = alert["body"] as? String,
              let data = payload["data"] as? String,
              let notificationID = payload["id"] as? String,
              let user = DBUserManagerRepository().getUser()
        else {
            return
        }
        
        if user.id == nil{
            return
        }

        Constants.printLogs("Push payload: \(payload), type: \(type), Body: \(body)")
        
        //Actively setting app badge count if present
//        (payload["aps"] as? NSDictionary)
//            .flatMap { $0["badge"] as? Int }
//            .map { UIApplication.shared.applicationIconBadgeNumber = ($0) }
        
        if appWasActive{
            if let totalNotificationCount = payload["badge"] as? String{
                if let badge = Int(totalNotificationCount){
                    UIApplication.shared.applicationIconBadgeNumber = badge
                    let badgeCount = UserDefault.shared.getNotificationBadgeCount() + 1
                    UserDefault.shared.saveNotificationBadge(count: badgeCount)
                    NotificationCenter.default.post(name: .updateHomeNotificationCount, object: nil)
                }
            }
        }else{
            if let badge = aps["badge"] as? Int{
                UIApplication.shared.applicationIconBadgeNumber = badge
//                UserDefault.shared.saveNotificationBadge(count: badge)
//                NotificationCenter.default.post(name: .updateHomeNotificationCount, object: nil)
            }
        }
        
        (payload["notification_id"] as? String).map(markNotificationAsSeen)
        if !appWasActive{
            handleNotificationTaped(type: type, title: title, body: body, data: data, notificationID: notificationID)
        }
    }
    
    private static func handleNotificationTaped(type: String,title: String,body: String,data: String,notificationID: String) {
        let userInfo : [String: Any] = [.type: type,.data : data,.title : title,.body : body,.notificationID: notificationID]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.post(name: .pushNotificationReceived, object: nil,userInfo: userInfo)
        }
    }
    
}
