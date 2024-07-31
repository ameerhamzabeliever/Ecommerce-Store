//
//  MyFavoritesVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SYBadgeButton

class MyFavoritesVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cartBtn: SYBadgeButton!
    @IBOutlet weak var pisiffikLbl: UILabel!
    @IBOutlet weak var pisiffikView: UIView!
    @IBOutlet weak var pisiffikBtn: UIButton!{
        didSet{
            pisiffikBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var othersLbl: UILabel!
    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var othersBtn: UIButton!{
        didSet{
            othersBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var recipeLbl: UILabel!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var recipeBtn: UIButton!{
        didSet{
            recipeBtn.tintColor = .clear
        }
    }
    
    //MARK: - PROPERTIES -
    
    var favoritesTabs: MyFavoritesContainerVC?
    
    var currentSelectedIndex : Int = 0
    var currentBadge : Int = 3
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        setCurrentFavoritesOf(type: .pisiffik)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setCartBadgeValue()
        self.observers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.favorites()
        pisiffikLbl.text = PisiffikStrings.pisiffikItems()
        othersLbl.text = PisiffikStrings.otherItems()
        recipeLbl.text = PisiffikStrings.recipes()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        pisiffikLbl.font = Fonts.semiBoldFontsSize16
        othersLbl.font = Fonts.semiBoldFontsSize16
        recipeLbl.font = Fonts.semiBoldFontsSize16
        setInboxTab()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateShopingListCounter(_:)), name: .myFavoritesShoppingListCounter, object: nil)
    }
    
    func setInboxTab(){
        guard let favoritesTabs = self.children.first as? MyFavoritesContainerVC else {return}
        self.favoritesTabs = favoritesTabs
        favoritesTabs.setSelectedTab = { (index, value) in
            print("Index: \(index)")
        }
    }
    
    private func setCartBadgeValue(){
        
        switch currentSelectedIndex{
        case 0:
            cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        case 1:
            cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
//            cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getCartListCount())
        case 2:
            cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        default:
            Constants.printLogs("*******")
        }
        
    }
    
    private func navigateToCartVC() {
//        guard let cartVC = R.storyboard.homeSB.myCartVC() else {return}
//        self.push(controller: cartVC, hideBar: true, animated: true)
    }
    
    private func navigateToShopingListVC() {
        guard let myShoppingListVC = R.storyboard.homeSB.myShoppingListVC() else {return}
        self.push(controller: myShoppingListVC, hideBar: true, animated: true)
    }
    
    @objc private func didUpdateShopingListCounter(_ notification: NSNotification){
        if currentSelectedIndex != 1{
            if let notificationObj = notification.userInfo as? [String: Any]{
                if let counter = notificationObj[.counter] as? String{
                    self.cartBtn.badgeValue = Utils.shared.getShoppingList(count: Int(counter) ?? 0)
                }else{
                    self.cartBtn.badgeValue = ""
                }
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapCartBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            self.navigateToShopingListVC()
//            if self.currentSelectedIndex == 1{
//                self.navigateToCartVC()
//            }else{
//                self.navigateToShopingListVC()
//            }
        }
    }
    
    @IBAction func didTapFavoritesBtns(_ sender: UIButton){
        switch sender.tag{
        case 0:
            setCurrentFavoritesOf(type: .pisiffik)
        case 1:
            setCurrentFavoritesOf(type: .others)
        case 2:
            setCurrentFavoritesOf(type: .recipe)
        default:
            Constants.printLogs("........")
        }
    }
    
}


//MARK: - EXTENSION FOR CONTAINER VIEWS SETUP -

extension MyFavoritesVC{
    
    fileprivate func setCurrentFavoritesOf(type: MyFavoritesType){
        
        switch type {
        case .pisiffik:
            
            self.pisiffikBtn.isSelected = true
            self.othersBtn.isSelected = false
            self.recipeBtn.isSelected = false
            self.pisiffikLbl.textColor = R.color.lightBlueColor()
            self.othersLbl.textColor = R.color.darkGrayColor()
            self.recipeLbl.textColor = R.color.darkGrayColor()
            self.pisiffikView.backgroundColor = R.color.lightBlueColor()
            self.othersView.backgroundColor = .white
            self.recipeView.backgroundColor = .white
            self.cartBtn.setImage(R.image.ic_white_cart_list_icon(), for: .normal)
            setPisiffikVC()
            self.currentSelectedIndex = 0
            self.setCartBadgeValue()
            
        case .others:
            
            self.pisiffikBtn.isSelected = false
            self.othersBtn.isSelected = true
            self.recipeBtn.isSelected = false
            self.pisiffikLbl.textColor = R.color.darkGrayColor()
            self.othersLbl.textColor = R.color.lightBlueColor()
            self.recipeLbl.textColor = R.color.darkGrayColor()
            self.pisiffikView.backgroundColor = .white
            self.recipeView.backgroundColor = .white
            self.othersView.backgroundColor = R.color.lightBlueColor()
            self.cartBtn.setImage(R.image.ic_white_cart_list_icon(), for: .normal)
            setOthersVC()
            self.currentSelectedIndex = 1
            self.setCartBadgeValue()
            
        case .recipe:
            
            self.pisiffikBtn.isSelected = false
            self.othersBtn.isSelected = false
            self.recipeBtn.isSelected = true
            self.pisiffikLbl.textColor = R.color.darkGrayColor()
            self.othersLbl.textColor = R.color.darkGrayColor()
            self.recipeLbl.textColor = R.color.lightBlueColor()
            self.pisiffikView.backgroundColor = .white
            self.othersView.backgroundColor = .white
            self.recipeView.backgroundColor = R.color.lightBlueColor()
            self.cartBtn.setImage(R.image.ic_white_cart_list_icon(), for: .normal)
            setRecipeVC()
            self.currentSelectedIndex = 2
            self.setCartBadgeValue()
            
        }
        
    }
    
}



//MARK: - EXTENSION FOR NAVIGATION FUNC -

extension MyFavoritesVC {
    
    func setPisiffikVC() {
        favoritesTabs?.setViewContollerAtIndex(index: 0, animate: false)
    }
    
    func setOthersVC() {
        favoritesTabs?.setViewContollerAtIndex(index: 1, animate: false)
    }
    
    func setRecipeVC() {
        favoritesTabs?.setViewContollerAtIndex(index: 2, animate: false)
    }
    
    
}
