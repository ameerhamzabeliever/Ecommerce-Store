//
//  AppDelegate.swift
//  pisiffik_ios
//
//  Copyright © softwareAlliance. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import netfox
import GooglePlaces
import UserNotifications
import FirebaseCore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate{

    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
    
    var fcm_Tokken: String = ""
    var deviceToken: String = ""

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //Firebase
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Notifications
        
        notificationsHandler.configure()
        configureNotification(application: application)
        
        // App structure
        router.loadMainAppStructure()
        
        IQKeyboardManager.shared.enable = true
        
        //Location Manager
        LocationManager.shared.startUpdatingLocation()
        
        // Set the App to Dark Mode...
        window?.overrideUserInterfaceStyle = .light
        
        NFX.sharedInstance().start()
        
        //Messaging...
        
        Messaging.messaging().token { token, error in
            if let error = error {
                Constants.printLogs("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                Constants.printLogs("FCM registration token: \(token)")
                self.fcm_Tokken  = token
            }
        }
        
        // Google Places
        GMSPlacesClient.provideAPIKey(Constants.APIKey)
        
        //Setup TableView Section Height...
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        
        //Setup ScrollView Top Extra Spacing While Scrolling...
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            UIScrollView.appearance().automaticallyAdjustsScrollIndicatorInsets = false
        }
        

        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // To enable full remote notifications functionality you should first register the device with your api service
        //https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/
        notificationsHandler.handleRemoteNotification(with: userInfo)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func configureNotification(application: UIApplication){
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {granted, error in
                    if granted {
                        print("Permession Granted for Notification")
                    } else {
                        print("Permession Not granter Notification")
                    }
                })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //  print("FCM token \(fcmToken ?? "NIL")")
        guard let tokken = fcmToken else {return}
        fcm_Tokken = tokken
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        self.fcm_Tokken = fcmToken
        // ConnectionManager.updateFcmTokken(fcmToken: fcmToken) { (resp) in }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.deviceToken = token
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // print("Notifications not available in simulator \(error)")
    }
    
    // This method will be called when app received push notifications in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("=== Push Received === *** APP ACTIVE *** ")
        PushManager.handlePush(notification.request.content.userInfo,
                               appWasActive: true)
        if #available(iOS 14.0, *) {
            completionHandler(.list)
        } else {
            completionHandler(.sound)
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("=== Push Received === *** APP BACKGROUND ***")
        PushManager.handlePush(userInfo,
                               appWasActive: UIApplication.shared.applicationState == .active)
    }
    
}
