//
//  RootRouter.swift
//  pisiffik_ios
//
//  Copyright © softwareAlliance. All rights reserved.
//

import UIKit

class RootRouter {

    /** Replaces root view controller. You can specify the replacment animation type.
     If no animation type is specified, there is no animation */
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("No window in app")
        }
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
    
    func open(viewController: UIViewController) {
        if let user = DBUserManagerRepository().getUser(), user.id != nil{
            guard let homeBoard = R.storyboard.mainTabbarSB.mainTabBarViewController() else {return}
            setRootViewController(controller: homeBoard, animatedWithOptions: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let window = UIApplication.shared.windows.first else {
                    fatalError("No window in app")
                }
                if let navCntrl = window.rootViewController as? UINavigationController {
                    navCntrl.pushViewController(viewController, animated: false)
                }
            }
        }
    }

    func loadMainAppStructure() {
        
        loadCustomSplashScreens()
        
    }
    
    func loadCustomSplashScreens() {
        guard let splashVC = R.storyboard.introSB.splashNavigationVC() else {
            return
        }
        setRootViewController(controller: splashVC, animatedWithOptions: nil)
    }
    
    func loadIntroScreens() {
        guard let introNavigation = R.storyboard.introSB.introNavigationVC() else {
            return
        }
        setRootViewController(controller: introNavigation, animatedWithOptions: nil)
    }
    
    func loadAuthenticationScreens() {
        guard let authNavigation = R.storyboard.authSB.authNavigationVC() else {
            return
        }
        setRootViewController(controller: authNavigation, animatedWithOptions: nil)
    }
    
    func logoutUserIsUnAutenticated(){
        
        UserDefault.shared.saveNotificationBadge(count: 0)
        UserDefault.shared.deleteAllNotificationsID()
        UIApplication.shared.applicationIconBadgeNumber = 0
        DBUserManagerRepository().deleteAllRecord()
        EventLocalManager.shared.deleteAllLocalEvent()
        NewsLocalManager.shared.deleteAllNewsID()
        EventIDLocalManager.shared.deleteAllEventID()
        UserDefault.shared.saveMedia(url: "")
        
        guard let welcomBoard = R.storyboard.authSB.authNavigationVC() else {
            return
        }
        setRootViewController(controller: welcomBoard, animatedWithOptions: nil)
        
    }
    
    
    func loadMainTabbarScreens() {
       
        guard let mainTabBarViewController = R.storyboard.mainTabbarSB.mainTabBarViewController() else {
            return
        }
        setRootViewController(controller: mainTabBarViewController, animatedWithOptions: nil)
    }
    
}
