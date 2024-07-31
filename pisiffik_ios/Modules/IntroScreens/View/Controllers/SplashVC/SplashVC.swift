//
//  SplashVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    var viewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefault.shared.saveAccessTokenForResetPassword(token: "")
        navigateFromSplash()
        // Do any additional setup after loading the view.
    }

    private func navigateFromSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch self.viewModel.loadViewController(){
            case .languageVC:
                self.navigateToLanguageVC()
            case .loginVC:
                self.navigateToLoginVC()
            case .homeVC:
                RootRouter().loadMainTabbarScreens()
            }
        }
    }
    
}


//MARK: - EXTENSION FOR NAVIGATION -

extension SplashVC{
    
    private func navigateToLanguageVC() {
        guard let languageVC = R.storyboard.languageBoard.languageVC() else {return}
        self.navigationController?.pushViewController(languageVC, animated: false)
    }
    
    private func navigateToLoginVC(){
        let router = RootRouter()
        guard let loginViewController = R.storyboard.authSB.authNavigationVC() else {
            return
        }
        router.setRootViewController(controller: loginViewController, animatedWithOptions: nil)
    }
}
