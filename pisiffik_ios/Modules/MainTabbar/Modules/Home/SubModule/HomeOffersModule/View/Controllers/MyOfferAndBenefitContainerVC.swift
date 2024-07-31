//
//  MyOfferAndBenefitContainerVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class MyOfferAndBenefitContainerVC: UIPageViewController {
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            R.storyboard.homeOffersSB.myOfferPersonalVC() ?? UIViewController(),
            R.storyboard.homeOffersSB.myOfferLocalVC() ?? UIViewController(),
            R.storyboard.homeOffersSB.myOfferMembershipVC() ?? UIViewController()
        ]
    }()
    
    var setSelectedTab: ((_ index: Int, _ value: Any?) -> Void)?
    var mode: MyOfferAndBenefitMode = .forPersonal
    
    
    var currentIndex: Int{
        guard let vc = viewControllers?.first else{ return 0}
        return subViewControllers.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    private func setupView () {
        self.delegate = self
        self.dataSource = self
        
        switch mode {
        case .fromHome, .fromProfile, .forPersonal:
            self.setPersonalTab()
        case .forLocal:
            self.setLocalTab()
        case .forMembership:
            self.setMembershipTab()
        }
        
        
        self.isPagingEnabled = false
        
        /* NotificationCenter.default.addObserver(self, selector: #selector(setPersonalTab), name: .personalTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLocalTab), name: .localTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setMembershipTab), name: .membershipTab, object: nil)*/ 
        
    }
    
    @objc func setPersonalTab() {
        setViewContollerAtIndex(index: 0)
        self.setSelectedTab?(0, nil)
    }
    
    @objc func setLocalTab() {
        setViewContollerAtIndex(index: 1)
        self.setSelectedTab?(1, nil)
    }
    
    @objc func setMembershipTab() {
        self.setViewContollerAtIndex(index: 2)
        self.setSelectedTab?(2, nil)
    }
    
    func setViewContollerAtIndex (index: Int, animate: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: .forward, animated: animate, completion: nil)
    }
    
    
}


extension MyOfferAndBenefitContainerVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
