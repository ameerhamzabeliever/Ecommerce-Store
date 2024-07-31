//
//  MyOfferPersonalVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class MyOfferPersonalVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var conceptLbl: UILabel!{
        didSet{
            conceptLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var conceptCollectionView: UICollectionView!{
        didSet{
            conceptCollectionView.delegate = self
            conceptCollectionView.dataSource = self
            conceptCollectionView.register(R.nib.offerTabsTopCell)
        }
    }
    @IBOutlet weak var gridBtn: UIButton!{
        didSet{
            gridBtn.tag = 0
            gridBtn.tintColor = .clear
            gridBtn.setImage(R.image.ic_unselect_grid_icon(), for: .normal)
            gridBtn.setImage(R.image.ic_select_grid_icon(), for: .selected)
            gridBtn.isSelected = true
        }
    }
    @IBOutlet weak var listBtn: UIButton!{
        didSet{
            listBtn.tag = 1
            listBtn.tintColor = .clear
            listBtn.setImage(R.image.ic_unselect_list_icon(), for: .normal)
            listBtn.setImage(R.image.ic_select_list_icon(), for: .selected)
            listBtn.isSelected = false
        }
    }
    @IBOutlet weak var itemsCollectionView: UICollectionView!{
        didSet{
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
            itemsCollectionView.register(R.nib.homeOfferCollectionCell)
            itemsCollectionView.register(R.nib.personalOfferListCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private let allOffersVM = AllOffersViewModel()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    private var arrayOfProducts: [OfferList] = []
    private var arrayOfConcepts: [AllOffersConcepts] = []
    private var mediaURL: String = UserDefault.shared.getMediaURL()
    var currentSelectedIndex : Int = 0
    private var isLoading: Bool = false{
        didSet{
            if (isLoading && self.arrayOfConcepts.isEmpty){
                self.conceptLbl.showAnimatedGradientSkeleton()
                self.gridBtn.isHidden = true
                self.listBtn.isHidden = true
            }else{
                self.conceptLbl.hideSkeleton()
                self.gridBtn.isHidden = false
                self.listBtn.isHidden = false
            }
        }
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        allOffersVM.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        getAllOffers(of: .personal)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        conceptLbl.text = PisiffikStrings.concept()
        seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
    }
    
    func setUI() {
        conceptLbl.font = Fonts.mediumFontsSize14
        conceptLbl.textColor = R.color.textBlackColor()
        seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
        seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
        seeAllBtn.semanticContentAttribute = .forceRightToLeft
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getAllOffers(of type: MyOfferBenefitType){
        if !Network.isAvailable{
            self.itemsCollectionView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                let conceptID: Int = self.arrayOfConcepts.isEmpty == false ? self.arrayOfConcepts[self.currentSelectedIndex].id ?? 0 : 0
                let isBool: Bool = self.arrayOfConcepts.isEmpty == false ? false : true
                let request = AllOffersRequest(conceptID: conceptID, type: type.rawValue, bool: isBool)
                self.allOffersVM.getAllOffersWith(request: request)
            }
        }else{
            self.isLoading = true
            let conceptID: Int = self.arrayOfConcepts.isEmpty == false ? self.arrayOfConcepts[self.currentSelectedIndex].id ?? 0 : 0
            let isBool: Bool = self.arrayOfConcepts.isEmpty == false ? false : true
            let request = AllOffersRequest(conceptID: conceptID, type: type.rawValue, bool: isBool)
            self.allOffersVM.getAllOffersWith(request: request)
        }
    }
    
    private func navigateToOfferDetailVC(index: Int){
        guard let offerID = self.arrayOfProducts[index].id else {return}
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = self.arrayOfProducts[index]
        offerDetailVC.offerID = offerID
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapSeeAllBtn(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapListDirectionChangeBtn(_ sender: UIButton) {
        self.setCollectionViewCellsDirection(at: sender.tag)
    }
    
}

//MARK: - EXTENSION FOR ALL OFFERS VIEWMODEL DELEGATES -

extension MyOfferPersonalVC: AllOffersViewModelDelegate{
    
    func didReceiveAllOffers(response: AllOffersResponse) {
        self.isLoading = false
        if let concepts = response.data?.concepts,
           !concepts.isEmpty,
           let products = response.data?.offer{
            self.arrayOfConcepts.removeAll()
            self.arrayOfProducts.removeAll()
            self.arrayOfConcepts = concepts
            let allObj = AllOffersConcepts(id: 0, name: PisiffikStrings.all(), image: nil, isPrefered: 0)
            self.arrayOfConcepts.insert(allObj, at: 0)
            self.arrayOfProducts = products
            self.mediaURL = response.data?.media_url ?? UserDefault.shared.getMediaURL()
        }
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
            self?.conceptCollectionView.reloadData()
        }
    }
    
    func didReceiveAllOffersResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.conceptCollectionView.reloadData()
        self.itemsCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.itemsCollectionView.reloadData()
            self.itemsCollectionView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.getAllOffers(of: .personal)
            }
        }
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension MyOfferPersonalVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        if let isFavorite = response.data?.isFavorite{
            self.arrayOfProducts[indexPath].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
        }
    }
    
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension MyOfferPersonalVC: AddPisiffikItemToCartViewModelDelegate{
    
    func didAddPisiffikItemsToCart(response: AddPisiffikProductToShoppingResponse) {
        if let count = response.data?.totalQuantity{
            UserDefault.shared.saveShoppingList(count: count)
            self.addNewShoppingListNotification()
        }
        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToAddPisiffikItemsToCartWith(error: [String]?, at IndexPath: Int) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR OFFER DETAIL DELEGATES -

extension MyOfferPersonalVC: PisiffikItemDetailProtocol{
    
    func didPisiffikItem(isFavorite: Int,by id: Int){
        guard let index = self.arrayOfProducts.firstIndex(where: {$0.id == id}) else {return}
        self.arrayOfProducts[index].isFavorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
    }
    
}

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension MyOfferPersonalVC: AddToFavoriteViewModelDelegate{
    
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.arrayOfProducts[indexPath].isFavorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
    }
    
    func didFailToFoodItemToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension MyOfferPersonalVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
            
        case conceptCollectionView:
            return (isLoading && self.arrayOfConcepts.isEmpty) ? 10 : self.arrayOfConcepts.count
            
        case itemsCollectionView:
            return isLoading ? 10 : self.arrayOfProducts.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
            
        case conceptCollectionView:
            return configureConceptCell(at: indexPath)
            
        case itemsCollectionView:
            if gridBtn.isSelected{
                return configureGridCell(at: indexPath)
            }else{
                return configureListCell(at: indexPath)
            }
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        switch collectionView{
        case conceptCollectionView:
            if indexPath.row == self.currentSelectedIndex {return}
            self.currentSelectedIndex = indexPath.row
            self.getAllOffers(of: .personal)
            self.conceptCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .centeredHorizontally, animated: true)
            self.conceptCollectionView.reloadData()
            self.itemsCollectionView.reloadData()
            
        case itemsCollectionView:
            self.navigateToOfferDetailVC(index: indexPath.row)
            
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case conceptCollectionView:
            let size = self.conceptCollectionView.frame.size
            return CGSize(width: 120.0, height: size.height)
        case itemsCollectionView:
            let width = (self.itemsCollectionView.frame.width - 10)
            if gridBtn.isSelected{
                if UIDevice().userInterfaceIdiom == .phone{
                    return CGSize(width: width / 2, height: 260.0)
                }else{
                    return CGSize(width: width / 4, height: 275.0)
                }
            }else{
                return CGSize(width: (width), height: 148.0)
            }
        default:
            return CGSize(width: 0.0, height: 0.0)
        }
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW CELLS METHOD -

extension MyOfferPersonalVC{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.conceptCollectionView.dequeueReusableCell(withReuseIdentifier: .offerTabsTopCell, for: indexPath) as! OfferTabsTopCell
        
        if (isLoading && self.arrayOfConcepts.isEmpty){
            cell.setSkeletonView()
            cell.backView.layer.borderWidth = 0
            
        }else{
            cell.hideSkeletonView()
            
            let concept =  self.arrayOfConcepts[indexPath.row]
            
            cell.nameLbl.text = concept.name
            if indexPath.row == 0{
                cell.nameLbl.isHidden = false
                cell.offerImageView.isHidden = true
            }else{
                cell.nameLbl.isHidden = true
                cell.offerImageView.isHidden = false
            }
            
            if let imageURL = URL(string: "\(self.mediaURL)\(concept.image ?? "")"){
                cell.offerImageView.kf.indicatorType = .activity
                cell.offerImageView.kf.setImage(with: imageURL)
            }
            
            if indexPath.row == self.currentSelectedIndex{
                cell.backView.layer.borderWidth = 1
            }else{
                cell.backView.layer.borderWidth = 0
            }
            
        }
        
        return cell
    }
    
    private func configureListCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .personalOfferListCell, for: indexPath) as! PersonalOfferListCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let offer = self.arrayOfProducts[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.itemNameLbl.text = offer.name
            
            if let isDiscounted = offer.isDiscountEnabled,
               let salePrice = offer.salePrice,
               let currency = offer.currency{
                if isDiscounted{
                    cell.discountedPriceLbl.isHidden = false
                    cell.discountedPriceLbl.attributedText = "\(salePrice) \(currency)".strikeThrough()
                    cell.currentPriceLbl.text = "\(offer.afterDiscountPrice ?? 0) \(currency)"
                }else{
                    cell.discountedPriceLbl.isHidden = true
                    cell.currentPriceLbl.text = "\(salePrice) \(currency)"
                }
            }else{
                cell.discountedPriceLbl.isHidden = true
                cell.currentPriceLbl.text = "\(offer.salePrice ?? 0) \(offer.currency ?? "")"
            }
            
            if let points = offer.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = ""
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            if let expireIn = offer.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = ""
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = offer.isFavorite,
               isFavorite > 0{
                cell.favoriteBtn.isSelected = true
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        if let isFavorite = offer.isFavorite{
                            let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfProducts[indexPath.row].id, offerItemID: self?.arrayOfProducts[indexPath.row].offerItemId)
                            if isFavorite == 0{
                                self?.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: indexPath.row)
                            }else{
                                self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                                self?.postUnfavoriteNotification(id: self?.arrayOfProducts[indexPath.row].id ?? 0, isFavorite: 0)
                            }
                        }
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        if Network.isAvailable{
                            guard let offerID = self?.arrayOfProducts[indexPath.row].id,
                                  let offerItemID = self?.arrayOfProducts[indexPath.row].offerItemId else {return}
                            let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                            self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
                        }else{
                            self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                        }
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
        }
        
        return cell
    }
    
    private func configureGridCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .homeOfferCollectionCell, for: indexPath) as! HomeOfferCollectionCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let offer = self.arrayOfProducts[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.titleLbl.text = offer.name
            
            if let isDiscounted = offer.isDiscountEnabled,
               let salePrice = offer.salePrice,
               let currency = offer.currency{
                if isDiscounted{
                    cell.discountPrice.attributedText = "\(salePrice) \(currency)".strikeThrough()
                    cell.priceLbl.text = "\(offer.afterDiscountPrice ?? 0) \(currency)"
                }else{
                    cell.discountPrice.text = " "
                    cell.priceLbl.text = "\(salePrice) \(currency)"
                }
            }else{
                cell.discountPrice.text = " "
                cell.priceLbl.text = "\(offer.salePrice ?? 0) \(offer.currency ?? "")"
            }
            
            if let points = offer.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = ""
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            if let expireIn = offer.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = ""
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = offer.isFavorite,
               isFavorite > 0{
                cell.favoriteBtn.isSelected = true
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if let isFavorite = offer.isFavorite{
                        let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfProducts[indexPath.row].id,offerItemID: self?.arrayOfProducts[indexPath.row].offerItemId)
                        if isFavorite == 0{
                            self?.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: indexPath.row)
                        }else{
                            self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                            self?.postUnfavoriteNotification(id: self?.arrayOfProducts[indexPath.row].id ?? 0, isFavorite: 0)
                        }
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if Network.isAvailable{
                        guard let offerID = self?.arrayOfProducts[indexPath.row].id,
                              let offerItemID = self?.arrayOfProducts[indexPath.row].offerItemId else {return}
                        let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                        self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
                    }else{
                        self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                    }
                }
            }
            
//            if UIDevice().userInterfaceIdiom == .phone{
//                cell.imageHeightConstrain.constant = 73.0
//                cell.itemImageView.contentMode = .scaleAspectFill
//            }else{
//                cell.imageHeightConstrain.constant = 98.0
//                cell.itemImageView.contentMode = .scaleAspectFit
//            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR PRIVATE METHODS -

extension MyOfferPersonalVC{
    
    private func setCollectionViewCellsDirection(at tag: Int){
        if isLoading {return}
        switch tag{
        case 0:
            self.gridBtn.isSelected = true
            self.listBtn.isSelected = false
            self.itemsCollectionView.reloadData()
        case 1:
            self.gridBtn.isSelected = false
            self.listBtn.isSelected = true
            self.itemsCollectionView.reloadData()
        default:
            return
        }
    }
    
}

//MARK: - EXTENSION FOR POST NOTIFICATION -

extension MyOfferPersonalVC{
    
    private func postUnfavoriteNotification(id: Int,isFavorite: Int){
        let userInfo : [String : Int] = [.foodItemID: id,.isFavorite: isFavorite]
        NotificationCenter.default.post(name: .foodItemFavoriteListUpdate, object: nil, userInfo: userInfo)
    }
    
    private func addNewShoppingListNotification(){
        let counter = String(UserDefault.shared.getShoppingListCount())
        let userInfo : [String : String] = [.counter: counter]
        NotificationCenter.default.post(name: .myFavoritesShoppingListCounter, object: nil, userInfo: userInfo)
    }
    
    private func removeNewShoppingListNotification(){
        let counter = String(UserDefault.shared.getShoppingListCount())
        let userInfo : [String : String] = [.counter: counter]
        NotificationCenter.default.post(name: .myFavoritesShoppingListCounter, object: nil, userInfo: userInfo)
    }
    
}
