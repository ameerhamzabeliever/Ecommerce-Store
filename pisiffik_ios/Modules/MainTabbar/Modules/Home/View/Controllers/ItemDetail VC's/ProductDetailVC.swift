//
//  ProductDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 21/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import FSPagerView
import ActiveLabel
import GMStepper
import SYBadgeButton

enum ProductType{
    case rebate
    case points
}

class ProductDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var itemsPagerView: FSPagerView!{
        didSet{
            itemsPagerView.delegate = self
            itemsPagerView.dataSource = self
            itemsPagerView.register(UINib(nibName: .offerItemsPagerCell, bundle: nil), forCellWithReuseIdentifier: .offerItemsPagerCell)
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.setImage(R.image.ic_unselect_favorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_select_favorite_icon(), for: .selected)
        }
    }
    @IBOutlet weak var cartBtn: UIButton!{
        didSet{
            cartBtn.setImage(R.image.ic_unselect_cart_icon(), for: .normal)
            cartBtn.setImage(R.image.ic_select_cart_icon(), for: .selected)
        }
    }
    @IBOutlet weak var cartListBtn: SYBadgeButton!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var itemTableView: ContentSizedTableView!{
        didSet{
            itemTableView.delegate = self
            itemTableView.dataSource = self
            itemTableView.register(R.nib.offerSinglePurchaseCell)
            itemTableView.register(R.nib.offersEarnPointsCell)
            itemTableView.register(R.nib.offersInfoCell)
        }
    }
    @IBOutlet weak var storeTableView: ContentSizedTableView!{
        didSet{
            storeTableView.delegate = self
            storeTableView.dataSource = self
            storeTableView.register(R.nib.offersAvailableStoreCell)
        }
    }
    @IBOutlet weak var expireInLbl: UILabel!
    @IBOutlet weak var availableAtStoreLbl: UILabel!
    
    @IBOutlet weak var stepperView: GMStepper!{
        didSet{
            stepperView.labelFont = Fonts.semiBoldFontsSize14 ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        }
    }
    @IBOutlet weak var currentPriceLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    //MARK: - PROPERTIES -
    
    var earnPoints : Int = 15
    var earnKr : Int = 200000
    var mode: ProductType = {
        let mode : ProductType = .points
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setUpPagerViewProperties()
        favoriteBtn.isSelected = true
        self.cartListBtn.badgeValue = ""
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.details()
        priceLbl.attributedText = "2,499.00 kr.".strikeThrough()
        addToCartBtn.setTitle(PisiffikStrings.addToCart(), for: .normal)
        expireInLbl.text = "\(PisiffikStrings.expireIn()) 2 days"
        availableAtStoreLbl.text = PisiffikStrings.availableAtStores()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        currentPriceLbl.font = Fonts.semiBoldFontsSize16
        currentPriceLbl.textColor = R.color.textBlueColor()
        priceLbl.font = Fonts.mediumFontsSize10
        priceLbl.textColor = R.color.textGrayColor()
        expireInLbl.font = Fonts.mediumFontsSize12
        expireInLbl.textColor = R.color.textRedColor()
        availableAtStoreLbl.font = Fonts.mediumFontsSize18
        availableAtStoreLbl.textColor = R.color.textBlackColor()
        addToCartBtn.titleLabel?.font = Fonts.mediumFontsSize14
        addToCartBtn.setTitleColor(.white, for: .normal)
        addToCartBtn.backgroundColor = R.color.darkBlueColor()
        HeaderView.layer.cornerRadius = 40.0
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    fileprivate func setUpPagerViewProperties(){
        itemsPagerView.automaticSlidingInterval = 0.0
        itemsPagerView.transformer = FSPagerViewTransformer(type: .linear)
        //Page Controll...
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(R.color.textLightGrayColor(), for: .normal)
        pageControl.setFillColor(R.color.darkBlueColor(), for: .selected)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapDirectionBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let directionVC = R.storyboard.profileSB.directionVC() else {return}
            self.push(controller: directionVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddToCartBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let myCartVC = R.storyboard.homeSB.myCartVC() else {return}
            self.push(controller: myCartVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapFavoriteBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.favoriteBtn.isSelected{
                self.favoriteBtn.isSelected = false
            }else{
                self.favoriteBtn.isSelected = true
            }
        }
    }
    
    @IBAction func didTapStepperView(_ sender: GMStepper) {
        
    }
    
    @IBAction func didTapCartListBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            guard let myCartVC = R.storyboard.homeSB.myCartVC() else {return}
            self.push(controller: myCartVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapCartBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.cartBtn.isSelected = true
        }
    }
    
    
}


//MARK: - FSPAGER COLLECTION VIEW METODS -

extension ProductDetailVC: FSPagerViewMethods{
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        return configureItemsCell(at: index)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        Constants.printLogs("\(index)")
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
    
}

//MARK: - EXTENSION FOR FSPAGER CELL -

extension ProductDetailVC{
    
    fileprivate func configureItemsCell(at index: Int) -> FSPagerViewCell{
        let cell = itemsPagerView.dequeueReusableCell(withReuseIdentifier: .offerItemsPagerCell, at: index) as! OfferItemsPagerCell
        cell.itemImageView.image = R.image.ic_headphone_image()
        return cell
    }
    
}

//MARK: - ITEMS LIST VIEW METODS -

extension ProductDetailVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case itemTableView:
            return 2
        case storeTableView:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView{
        case storeTableView:
            return configureAvailableStoreCell(at: indexPath)
            
        case itemTableView:
            if indexPath.row == 0{
                return configurePointsCell(at: indexPath)
            }else if indexPath.row == 1{
                return configureInfoCellCell(at: indexPath)
            }else{
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - EXTENSION FOR ITEMS CELLS -

extension ProductDetailVC{
    
    fileprivate func configureSinglePurchaseCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = itemTableView.dequeueReusableCell(withIdentifier: .offerSinglePurchaseCell, for: indexPath) as! OfferSinglePurchaseCell
        
        cell.singlePurchaseLbl.text = PisiffikStrings.singlePurchase()
        cell.stockLbl.text = PisiffikStrings.inStock()
        cell.discountedPriceLbl.attributedText = "24.99 kr.".strikeThrough()
        
        return cell
    }
    
    fileprivate func configurePointsCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = itemTableView.dequeueReusableCell(withIdentifier: .offerEarnPointsCell, for: indexPath) as! OffersEarnPointsCell
        if self.mode == .points{
            let pointsType = ActiveType.custom(pattern: "\(earnPoints) \(PisiffikStrings.points())")
            cell.pointsLbl.enabledTypes = [pointsType]
            cell.pointsLbl.customColor[pointsType] = UIColor.appLightGreenColor
            cell.pointsLbl.text = "\(PisiffikStrings.youWillEarn()) \(earnPoints) \(PisiffikStrings.points()) \(PisiffikStrings.atPisiffik())"
        }else{
            let pointsType = ActiveType.custom(pattern: "\(earnPoints) \(PisiffikStrings.points())")
            let krType = ActiveType.custom(pattern: "\(earnKr) kr.")
            cell.pointsLbl.enabledTypes = [pointsType, krType]
            cell.pointsLbl.customColor[pointsType] = R.color.textGrayColor()
            cell.pointsLbl.customColor[krType] = UIColor.appLightGreenColor
            cell.pointsLbl.text = "\(PisiffikStrings.youWillSpent()) \(earnPoints) \(PisiffikStrings.points()) \(PisiffikStrings.andGetRebate()) \(earnKr) kr."
        }
        return cell
    }
    
    fileprivate func configureInfoCellCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = itemTableView.dequeueReusableCell(withIdentifier: .offersInfoCell, for: indexPath) as! OffersInfoCell
        
        cell.infoLbl.text = PisiffikStrings.info()
        cell.specificationLbl.text = PisiffikStrings.specification()
        
        if cell.detailView.isHidden == true{
            cell.specificationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.checkImage.image = R.image.ic_gray_downward_chevron()
        }else{
            cell.checkImage.image = R.image.ic_gray_upward_chevron()
            cell.specificationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        cell.checkBtn.addTapGestureRecognizer { [weak self] in
            if cell.detailView.isHidden == true{
                cell.detailView.isHidden = false
            }else{
                cell.detailView.isHidden = true
            }
            self?.itemTableView.reloadData()
        }
        
        return cell
    }
    
    fileprivate func configureAvailableStoreCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = storeTableView.dequeueReusableCell(withIdentifier: .offersAvailableStoreCell, for: indexPath) as! OffersAvailableStoreCell
        
       
        cell.distanceLbl.text = "2.5\(PisiffikStrings.km())"
        cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
        cell.directionBtn.tag = indexPath.row
        cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
}
