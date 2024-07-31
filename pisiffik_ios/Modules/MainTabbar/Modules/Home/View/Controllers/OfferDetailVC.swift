//
//  OfferDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import FSPagerView
import ActiveLabel
import GMStepper
import SYBadgeButton
import SkeletonView

enum PisiffikItemDetailMode{
    case fromHome
    case fromFavorites
    case fromOther
}

protocol PisiffikItemDetailProtocol{
    func didPisiffikItem(isFavorite: Int,by id: Int)
}

class OfferDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addToShoppingBtn: UIButton!{
        didSet{
            addToShoppingBtn.isSkeletonable = true
            addToShoppingBtn.setImage(R.image.ic_unselect_cart_list_icon(), for: .normal)
        }
    }
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var itemsPagerView: FSPagerView!{
        didSet{
            itemsPagerView.delegate = self
            itemsPagerView.dataSource = self
            itemsPagerView.register(UINib(nibName: .offerItemsPagerCell, bundle: nil), forCellWithReuseIdentifier: .offerItemsPagerCell)
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet{
            pageControl.isSkeletonable = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.setImage(R.image.ic_unselect_favorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_select_favorite_icon(), for: .selected)
            favoriteBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var cartListBtn: SYBadgeButton!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!{
        didSet{
            itemNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var itemTableView: ContentSizedTableView!{
        didSet{
            itemTableView.delegate = self
            itemTableView.dataSource = self
            itemTableView.register(R.nib.offersEarnPointsCell)
        }
    }
    @IBOutlet weak var storeTableView: ContentSizedTableView!{
        didSet{
            storeTableView.delegate = self
            storeTableView.dataSource = self
            storeTableView.register(R.nib.offersAvailableStoreCell)
        }
    }
    @IBOutlet weak var expireInLbl: UILabel!{
        didSet{
            expireInLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var availableAtStoreLbl: UILabel!{
        didSet{
            availableAtStoreLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var currentPriceLbl: UILabel!{
        didSet{
            currentPriceLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!{
        didSet{
            descriptionLbl.isSkeletonable = true
            descriptionLbl.numberOfLines = 3
        }
    }
    
    
    //MARK: - PROPERTIES -
    
    private var detailViewModel = PisiffikItemDetailViewModel()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    private var stores : [PisiffikItemDetailStores] = []
    private var isLoading : Bool = false{
        didSet{
            configureSkeletonView()
        }
    }
    private var expandableTextRange: NSRange?
    var offerData : OfferList = OfferList()
    var offerID : Int = -1
    
    var delegates : PisiffikItemDetailProtocol?
    
    var mode : PisiffikItemDetailMode = {
        let mode : PisiffikItemDetailMode = .fromHome
        return mode
    }()
    var isFavorite : Int = 0
    var isFavoriteChanged : Bool = false
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setUpPagerViewProperties()
        detailViewModel.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        getOfferDetailData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cartListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.details()
        itemNameLbl.text = offerData.name
        descriptionLbl.text = offerData.description
        if let isDiscounted = offerData.isDiscountEnabled,
           let salePrice = offerData.salePrice,
           let currency = offerData.currency{
            if isDiscounted{
                priceLbl.isHidden = false
                priceLbl.attributedText = "\(salePrice) \(currency)".strikeThrough()
                currentPriceLbl.text = "\(offerData.afterDiscountPrice ?? 0) \(currency)"
            }else{
                priceLbl.isHidden = true
                currentPriceLbl.text = "\(salePrice) \(currency)"
            }
        }else{
            priceLbl.isHidden = true
            currentPriceLbl.text = "\(offerData.salePrice ?? 0) \(offerData.currency ?? "")"
        }
        
        if let expireIn = offerData.expiresIn{
            if expireIn > 0{
                expireInLbl.isHidden = false
                expireInLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
            }else{
                expireInLbl.isHidden = true
            }
        }else{
            expireInLbl.isHidden = true
        }
        
        if let isFavorite = offerData.isFavorite{
            if isFavorite > 0{
                favoriteBtn.isSelected = true
            }else{
                favoriteBtn.isSelected = false
            }
        }else{
            favoriteBtn.isSelected = false
        }
        
        availableAtStoreLbl.text = PisiffikStrings.availableAtStores()
        
        if descriptionLbl.isTruncatedText{
            expandableTextRange = descriptionLbl.setExpandActionIfPossible(PisiffikStrings.seeMore(), textColor: R.color.textLightGrayColor() ?? .lightGray)
            descriptionLbl.addTapGestureRecognizer { [weak self] in
                self?.descriptionLbl.numberOfLines = 0
                self?.descriptionLbl.text = self?.offerData.description
            }
        }
        
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        itemNameLbl.textColor = R.color.textBlackColor()
        itemNameLbl.font = Fonts.boldFontsSize22
        currentPriceLbl.font = Fonts.semiBoldFontsSize16
        currentPriceLbl.textColor = R.color.textBlueColor()
        priceLbl.font = Fonts.mediumFontsSize10
        priceLbl.textColor = R.color.textGrayColor()
        expireInLbl.font = Fonts.mediumFontsSize12
        expireInLbl.textColor = R.color.textRedColor()
        availableAtStoreLbl.font = Fonts.mediumFontsSize18
        availableAtStoreLbl.textColor = R.color.textBlackColor()
        descriptionLbl.textColor = R.color.textGrayColor()
        descriptionLbl.font = Fonts.regularFontsSize12
        HeaderView.layer.cornerRadius = 40.0
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setUpPagerViewProperties(){
        itemsPagerView.automaticSlidingInterval = 0.0
        itemsPagerView.transformer = FSPagerViewTransformer(type: .linear)
        //Page Controll...
        pageControl.numberOfPages = self.offerData.images?.count ?? 1
        pageControl.currentPage = 0
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(R.color.textLightGrayColor(), for: .normal)
        pageControl.setFillColor(R.color.darkBlueColor(), for: .selected)
    }
    
    private func getOfferDetailData(){
        if offerID > 0{
            if !Network.isAvailable{
                itemsPagerView.isHidden = true
                storeTableView.isHidden = true
                self.itemTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) { [weak self] in
                    if Network.isAvailable{
                        self?.itemsPagerView.isHidden = false
                        self?.storeTableView.isHidden = false
                        let request = PisiffikItemDetailRequest(id: self?.offerID ?? -1, latitude: Double(LocationManager.shared.lat) ?? 0.0, longitude: Double(LocationManager.shared.long) ?? 0.0)
                        self?.detailViewModel.getPisiffikItemDetailBy(request: request)
                    }
                }
                self.itemTableView.reloadData()
            }else{
                isLoading = true
                let request = PisiffikItemDetailRequest(id: self.offerID, latitude: Double(LocationManager.shared.lat) ?? 0.0, longitude: Double(LocationManager.shared.long) ?? 0.0)
                self.detailViewModel.getPisiffikItemDetailBy(request: request)
            }
        }
    }
    
//    let request = PisiffikItemDetailRequest(id: self?.offerID, latitude: Double(LocationManager.shared.lat), longitude: Double(LocationManager.shared.long))
//    self.detailViewModel.getPisiffikItemDetailBy(request: request)
    
    //MARK: - ACTIONS -
    
    @objc func didTapDirectionBtn(_ sender: UIButton){
        sender.showAnimation {
            if Network.isAvailable{
                if !LocationManager.shared.userDeniedLocation{
                    
                    if let latitude = self.stores[sender.tag].latitude,
                       let longitude = self.stores[sender.tag].longitude,
                       let destinationLat = Double(latitude),
                       let destinationLng = Double(longitude),
                       let currentLat = Double(LocationManager.shared.lat),
                       let currentLng = Double(LocationManager.shared.long){
                        
                        guard let directionVC = R.storyboard.profileSB.directionVC() else {return}
                        directionVC.currentLat = currentLat
                        directionVC.currentLng = currentLng
                        directionVC.destinationLat = destinationLat
                        directionVC.destinationLng = destinationLng
                        directionVC.destinationName = self.stores[sender.tag].name ?? ""
                        self.push(controller: directionVC, hideBar: true, animated: true)
                        
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsStoreDirectionNotAvailable()])
                    }
                    
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), delegate: self)
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            if self.mode == .fromFavorites && self.isFavoriteChanged{
                self.delegates?.didPisiffikItem(isFavorite: self.isFavorite, by: self.offerID)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddToShoppingListBtn(_ sender: UIButton){
        sender.showAnimation {
            if !self.isLoading{
                if Network.isAvailable{
                    let request = AddPisiffikProductRequest(variantID: self.offerID, offerItemID: self.offerData.offerItemId ?? 0, uomQuantity: 1)
                    self.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: sender.tag)
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
        }
    }
    
    @IBAction func didTapFavoriteBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.isLoading{
                if Network.isAvailable{
                    let request = AddFoodItemToFavoriteRequest(productID: self.offerID,offerItemID: self.offerData.offerItemId ?? 0)
                    if self.favoriteBtn.isSelected{
                        self.favoriteBtn.isSelected = false
                        self.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: sender.tag)
                    }else{
                        self.favoriteBtn.isSelected = true
                        self.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: sender.tag)
                    }
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
        }
    }
    
    @IBAction func didTapCartListBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            guard let myShoppingListVC = R.storyboard.homeSB.myShoppingListVC() else {return}
            self.push(controller: myShoppingListVC, hideBar: true, animated: true)
        }
    }
    
    
}

//MARK: - EXTENSION FOR DETAIL VIEW MODEL DELEGATES -

extension OfferDetailVC: PisiffikItemDetailViewModelDelegate{
    
    func didReceivePisiffikItemDetail(response: PisiffikItemDetailResponse) {
        self.isLoading = false
        if let stores = response.data?.stores{
            self.stores = stores
            if !self.stores.isEmpty{
                self.availableAtStoreLbl.isHidden = false
            }else{
                self.availableAtStoreLbl.isHidden = true
            }
        }else{
            self.availableAtStoreLbl.isHidden = true
        }
        DispatchQueue.main.async { [weak self] in
            self?.itemsPagerView.reloadData()
            self?.itemTableView.reloadData()
            self?.storeTableView.reloadData()
        }
    }
    
    func didReceivePisiffikItemDetailResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.itemsPagerView.reloadData()
            self?.itemTableView.reloadData()
            self?.storeTableView.reloadData()
        }
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.itemsPagerView.reloadData()
            self?.itemTableView.reloadData()
            self?.storeTableView.reloadData()
        }
    }
    
}


//MARK: - FSPAGER COLLECTION VIEW METODS -

extension OfferDetailVC: FSPagerViewMethods{
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return isLoading ? 3 : self.offerData.images?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        return configureItemsCell(at: index)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if isLoading {return}
        Constants.printLogs("\(index)")
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if !isLoading{
            self.pageControl.currentPage = targetIndex
        }
    }
    
}

//MARK: - EXTENSION FOR FSPAGER CELL -

extension OfferDetailVC{
    
    private func configureItemsCell(at index: Int) -> FSPagerViewCell{
        let cell = itemsPagerView.dequeueReusableCell(withReuseIdentifier: .offerItemsPagerCell, at: index) as! OfferItemsPagerCell
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            if let imageURL = URL(string: "\(self.offerData.images?[index] ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
    
}

//MARK: - ITEMS LIST VIEW METODS -

extension OfferDetailVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case itemTableView:
            return isLoading ? 1 : self.offerData.points ?? 0 > 0 ? 1 : 0
        case storeTableView:
            return isLoading ? 2 : self.stores.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView{
        case storeTableView:
            return configureAvailableStoreCell(at: indexPath)
            
        case itemTableView:
            return configurePointsCell(at: indexPath)

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - EXTENSION FOR ITEMS CELLS -

extension OfferDetailVC{
    
    
    private func configurePointsCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = itemTableView.dequeueReusableCell(withIdentifier: .offerEarnPointsCell, for: indexPath) as! OffersEarnPointsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            if let isMember = self.offerData.isMember,
               isMember == 1{
                let pointsType = ActiveType.custom(pattern: "\(self.offerData.points ?? 0) \(PisiffikStrings.points())")
                let rebateType = ActiveType.custom(pattern: "\(self.offerData.afterDiscountPrice ?? 0.0) \(self.offerData.currency ?? "").")
                cell.pointsLbl.enabledTypes = [pointsType, rebateType]
                cell.pointsLbl.customColor[pointsType] = UIColor.darkGray
                cell.pointsLbl.customColor[rebateType] = R.color.lightGreenColor()
                cell.pointsLbl.text = "\(PisiffikStrings.youWillSpent()) \(self.offerData.points ?? 0) \(PisiffikStrings.points()) \(PisiffikStrings.andGetRebate()) \(self.offerData.afterDiscountPrice ?? 0.0) \(self.offerData.currency ?? "")."
            }else{
                let pointsType = ActiveType.custom(pattern: "\(self.offerData.points ?? 0) \(PisiffikStrings.points())")
                cell.pointsLbl.enabledTypes = [pointsType]
                cell.pointsLbl.customColor[pointsType] = UIColor.appLightGreenColor
                cell.pointsLbl.text = "\(PisiffikStrings.youWillEarn()) \(self.offerData.points ?? 0) \(PisiffikStrings.points()) \(PisiffikStrings.atPisiffik())"
            }
                
        }
        
        return cell
    }
    
    private func configureAvailableStoreCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = storeTableView.dequeueReusableCell(withIdentifier: .offersAvailableStoreCell, for: indexPath) as! OffersAvailableStoreCell
        
        if isLoading{
            cell.setSkeletonView()
            cell.isLoading = true
            
        }else{
            cell.hideSkeletonView()
            cell.arrayOfTimings = self.stores[indexPath.row].timings ?? []
            cell.isLoading = false
            
            DispatchQueue.main.async {
                cell.hoursTableView.reloadData()
            }
            
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.stores[indexPath.row].conceptImage ?? "")"){
                cell.storeImageView.kf.indicatorType = .activity
                cell.storeImageView.kf.setImage(with: imageURL)
            }
            cell.distanceLbl.text = "\(self.stores[indexPath.row].distance ?? "")"
            
            let customType = ActiveType.custom(pattern: "\(self.stores[indexPath.row].name ?? ""),")
            cell.addressLbl.enabledTypes = [customType]
            cell.addressLbl.customColor[customType] = R.color.textLightBlackColor()
            cell.addressLbl.text = "\(self.stores[indexPath.row].name ?? ""), \(self.stores[indexPath.row].address ?? "")"
            
            cell.openingHoursLbl.text = PisiffikStrings.openingHours()
            
            cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
            cell.directionBtn.tag = indexPath.row
            cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    
}

//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension OfferDetailVC: AddPisiffikItemToCartViewModelDelegate{
    
    func didAddPisiffikItemsToCart(response: AddPisiffikProductToShoppingResponse) {
        if let count = response.data?.totalQuantity{
            UserDefault.shared.saveShoppingList(count: count)
            self.cartListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        }
        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToAddPisiffikItemsToCartWith(error: [String]?, at IndexPath: Int) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension OfferDetailVC: AddToFavoriteViewModelDelegate{
    
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.offerData.isFavorite = isFavorite
        
        if mode == .fromHome{
            self.delegates?.didPisiffikItem(isFavorite: isFavorite, by: self.offerID)
        }else if mode == .fromFavorites{
            self.isFavorite = isFavorite
            self.isFavoriteChanged = true
            self.didUpdateHomeOfferList(by: self.offerID, isFavorite: isFavorite)
        }else{
            self.didUpdateHomeOfferList(by: self.offerID, isFavorite: isFavorite)
        }
    }
    
    func didFailToFoodItemToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            if self?.favoriteBtn.isSelected == true{
                self?.favoriteBtn.isSelected = false
            }else{
                self?.favoriteBtn.isSelected = true
            }
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension OfferDetailVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.offerData.isFavorite = isFavorite
        
        if mode == .fromHome{
            self.delegates?.didPisiffikItem(isFavorite: isFavorite, by: self.offerID)
        }else if mode == .fromFavorites{
            self.isFavorite = isFavorite
            self.isFavoriteChanged = true
            self.didUpdateHomeOfferList(by: self.offerID, isFavorite: isFavorite)
        }else{
            self.didUpdateHomeOfferList(by: self.offerID, isFavorite: isFavorite)
        }
    }
    
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            if self?.favoriteBtn.isSelected == true{
                self?.favoriteBtn.isSelected = false
            }else{
                self?.favoriteBtn.isSelected = true
            }
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - EXTENSION FOR POST NOTIFICATIONS -

extension OfferDetailVC{
    
    private func didUpdateHomeOfferList(by id: Int,isFavorite: Int){
        let userInfo : [String: Int] = [.foodItemID: id,.isFavorite: isFavorite]
        NotificationCenter.default.post(name: .foodItemFavoriteListUpdate, object: nil, userInfo: userInfo)
    }
    
}


//MARK: - EXTENSION FOR ALERT VC DELEGATES -

extension OfferDetailVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}


//MARK: - SKELETON VIEW METHODS -

extension OfferDetailVC{
    
    private func configureSkeletonView(){
        if isLoading{
            self.setSkeletonView()
        }else{
            self.hideSkeletonView()
        }
    }
    
    private func setSkeletonView(){
        addToShoppingBtn.showAnimatedGradientSkeleton()
        itemNameLbl.showAnimatedGradientSkeleton()
        pageControl.showAnimatedGradientSkeleton()
        favoriteBtn.showAnimatedGradientSkeleton()
        expireInLbl.showAnimatedGradientSkeleton()
        availableAtStoreLbl.showAnimatedGradientSkeleton()
        currentPriceLbl.showAnimatedGradientSkeleton()
        descriptionLbl.showAnimatedGradientSkeleton()
        priceLbl.isHidden = true
    }
    
    private func hideSkeletonView(){
        addToShoppingBtn.hideSkeleton()
        itemNameLbl.hideSkeleton()
        pageControl.hideSkeleton()
        favoriteBtn.hideSkeleton()
        expireInLbl.hideSkeleton()
        availableAtStoreLbl.hideSkeleton()
        currentPriceLbl.hideSkeleton()
        descriptionLbl.hideSkeleton()
        if let isDiscounted = offerData.isDiscountEnabled{
            if isDiscounted{
                priceLbl.isHidden = false
            }else{
                priceLbl.isHidden = true
            }
        }
    }
    
}
