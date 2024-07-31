//
//  MainTabBarViewController.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Localize_Swift

class MainTabBarViewController: UITabBarController {
    
    //MARK: - OUTLET -
    
    let indicatorPlatform = UIView()
    
    //MARK: - PROPERTIES -
    
    
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UIDevice().userInterfaceIdiom == .phone{
            self.setupIndicatorPlatform()
        }
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
       updateTabbatItemsText()
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func updateTabbatItemsText(){
        if let items = self.tabBar.items{
            if !items.isEmpty{
                for index in (0...(items.count - 1)){
                    switch index{
                    case 0:
                        items[index].title = PisiffikStrings.home()
                    case 1:
                        items[index].title = PisiffikStrings.offers()
                    case 2:
                        items[index].title = PisiffikStrings.more()
                    case 3:
                        items[index].title = PisiffikStrings.online()
                    case 4:
                        items[index].title = PisiffikStrings.scan()
                    default:
                        Constants.printLogs("**********")
                    }
                }
            }
        }
    }
    
    
    //MARK: - ACTIONS -
    
    
    
}

//MARK: - EXTENSION FOR TABBAR CUSTOM VIEW ADD -

extension MainTabBarViewController{
    

    private func setupIndicatorPlatform() {
        let tabBarItemSize = CGSize(width: tabBar.frame.width / CGFloat(tabBar.items!.count), height: tabBar.frame.height)
        indicatorPlatform.backgroundColor = tabBar.tintColor
        indicatorPlatform.frame = CGRect(x: 0.0, y: 0.0, width: tabBarItemSize.width, height: 3.0)
        indicatorPlatform.center.x = tabBar.frame.width / CGFloat(tabBar.items!.count) / 2.0
        tabBar.addSubview(indicatorPlatform)
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = CGFloat(integerLiteral: tabBar.items!.firstIndex(of: item)!)
        let itemWidth = indicatorPlatform.frame.width
        if UIDevice().userInterfaceIdiom == .phone{
            let newCenterX = (itemWidth / 2.0) + (itemWidth * index)
            
            UIView.animate(withDuration: 0.3) {
                tabBar.tintColor = R.color.lightBlueColor()
                self.indicatorPlatform.backgroundColor = R.color.lightBlueColor()
                self.indicatorPlatform.center.x = newCenterX
            }
        }else{
            
            let newCenterX = (itemWidth / 3.0) + (itemWidth * index)
            
            UIView.animate(withDuration: 0.3) {
                tabBar.tintColor = R.color.lightBlueColor()
                self.indicatorPlatform.backgroundColor = R.color.lightBlueColor()
                self.indicatorPlatform.center.x = newCenterX
            }
            
        }
        
    }
    
}
