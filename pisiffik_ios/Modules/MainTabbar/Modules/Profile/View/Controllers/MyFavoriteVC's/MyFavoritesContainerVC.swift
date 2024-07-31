//
//  MyFavoritesContainerVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class MyFavoritesContainerVC: UIPageViewController {
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            R.storyboard.profileSB.pisiffikFavoritesVC() ?? UIViewController(),
            R.storyboard.profileSB.otherFavoritesVC() ?? UIViewController(),
            R.storyboard.profileSB.recipeFavoritesVC() ?? UIViewController()
        ]
    }()
    
    var setSelectedTab: ((_ index: Int, _ value: Any?) -> Void)?
    
    var currentIndex: Int{
        guard let vc = viewControllers?.first else{ return 0}
        return subViewControllers.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    private func setupView () {
        self.delegate = self
        self.dataSource = self
        setViewContollerAtIndex(index: 0)
        self.isPagingEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPisiffikFavoritesTab), name: .pisiffikFavoritesTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setOtherFavoritesTab), name: .otherFavoritesTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setRecipeFavoritesTab), name: .recipeFavoritesTab, object: nil)
        
    }
    
    @objc func setPisiffikFavoritesTab() {
        setViewContollerAtIndex(index: 0)
        self.setSelectedTab?(1, nil)
    }
    
    @objc func setOtherFavoritesTab() {
        setViewContollerAtIndex(index: 1)
        self.setSelectedTab?(2, nil)
    }
    
    @objc func setRecipeFavoritesTab() {
        setViewContollerAtIndex(index: 2)
        self.setSelectedTab?(3, nil)
    }
    
    
    func setViewContollerAtIndex (index: Int, animate: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: .forward, animated: animate, completion: nil)
    }
    
    
}


extension MyFavoritesContainerVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = subViewControllers.firstIndex(of: viewController){
            if currentIndex <= 0 {
                return nil
            }else{
                return subViewControllers[currentIndex - 1]
            }
        } else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = subViewControllers.firstIndex(of: viewController) {
            if currentIndex >= (subViewControllers.count - 1) {
                return nil
            } else {
                return subViewControllers[currentIndex + 1]
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            self.setSelectedTab?(self.currentIndex - 1 , nil)
        }
        
    }
    
}
