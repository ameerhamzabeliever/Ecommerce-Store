//
//  InboxVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

enum InboxMode{
    case news
    case events
    case tickets
}

class InboxVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var newsBtn: UIButton!{
        didSet{
            newsBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var eventsLbl: UILabel!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var eventsBtn: UIButton!{
        didSet{
            eventsBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationBtn: UIButton!{
        didSet{
            notificationBtn.tintColor = .clear
        }
    }
    
    //MARK: - PROPERTIES -
    
    var inboxTabs: InboxContainerVC?
    
    var mode : InboxMode = {
        let mode : InboxMode = .news
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setCurrentInboxOf(type: .news)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.inbox()
        newsLbl.text = PisiffikStrings.news()
        eventsLbl.text = PisiffikStrings.events()
        notificationLbl.text = PisiffikStrings.tickets()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        newsLbl.font = Fonts.semiBoldFontsSize16
        eventsLbl.font = Fonts.semiBoldFontsSize16
        notificationLbl.font = Fonts.semiBoldFontsSize16
        setInboxTab()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    func setInboxTab(){
        guard let inboxTabs = self.children.first as? InboxContainerVC else {return}
        self.inboxTabs = inboxTabs
        self.inboxTabs?.mode = self.mode
        inboxTabs.setSelectedTab = { (index, value) in
            switch index{
            case 0:
                self.setCurrentInboxOf(type: .news)
            case 1:
                self.setCurrentInboxOf(type: .events)
            case 2:
                self.setCurrentInboxOf(type: .tickets)
            default:
                Constants.printLogs("........")
            }
        }
    }

    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapInboxBtns(_ sender: UIButton){
        switch sender.tag{
        case 0:
            setCurrentInboxOf(type: .news)
            inboxTabs?.mode = .news
        case 1:
            setCurrentInboxOf(type: .events)
            inboxTabs?.mode = .events
        case 2:
            setCurrentInboxOf(type: .tickets)
            inboxTabs?.mode = .tickets
        default:
            Constants.printLogs("........")
        }
    }
    
}


//MARK: - EXTENSION FOR CONTAINER VIEWS SETUP -

extension InboxVC{
    
    fileprivate func setCurrentInboxOf(type: InboxType){
        
        switch type {
        case .news:
            
            self.newsBtn.isSelected = true
            self.eventsBtn.isSelected = false
            self.notificationBtn.isSelected = false
            self.newsLbl.textColor = R.color.lightBlueColor()
            self.eventsLbl.textColor = R.color.darkGrayColor()
            self.notificationLbl.textColor = R.color.darkGrayColor()
            self.newsView.backgroundColor = R.color.lightBlueColor()
            self.eventsView.backgroundColor = .white
            self.notificationView.backgroundColor = .white
            setNewsVC()
            
        case .events:
            
            self.newsBtn.isSelected = false
            self.eventsBtn.isSelected = true
            self.notificationBtn.isSelected = false
            self.newsLbl.textColor = R.color.darkGrayColor()
            self.eventsLbl.textColor = R.color.lightBlueColor()
            self.notificationLbl.textColor = R.color.darkGrayColor()
            self.newsView.backgroundColor = .white
            self.eventsView.backgroundColor = R.color.lightBlueColor()
            self.notificationView.backgroundColor = .white
            setEventsVC()
            
        case .tickets:
            
            self.newsBtn.isSelected = false
            self.eventsBtn.isSelected = false
            self.notificationBtn.isSelected = true
            self.newsLbl.textColor = R.color.darkGrayColor()
            self.eventsLbl.textColor = R.color.darkGrayColor()
            self.notificationLbl.textColor = R.color.lightBlueColor()
            self.newsView.backgroundColor = .white
            self.eventsView.backgroundColor = .white
            self.notificationView.backgroundColor = R.color.lightBlueColor()
            setTicketsVC()
            
        }
        
    }
    
}



//MARK: - EXTENSION FOR NAVIGATION FUNC -

extension InboxVC {
    
    func setNewsVC() {
        inboxTabs?.setViewContollerAtIndex(index: 0, animate: false)
    }
    
    func setEventsVC() {
        inboxTabs?.setViewContollerAtIndex(index: 1, animate: false)
    }
    
    func setTicketsVC() {
        inboxTabs?.setViewContollerAtIndex(index: 2, animate: false)
    }
    
}
