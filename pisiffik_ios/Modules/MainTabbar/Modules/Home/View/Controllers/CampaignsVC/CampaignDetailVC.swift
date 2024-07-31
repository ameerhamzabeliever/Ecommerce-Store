//
//  CampaignDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SYBadgeButton
import Kingfisher

class CampaignDetailVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var shoppingListBtn: SYBadgeButton!
    @IBOutlet weak var itemsCollectionView: UICollectionView!{
        didSet{
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
            itemsCollectionView.register(R.nib.homeOfferCollectionCell)
            itemsCollectionView.register(R.nib.personalOfferListCell)
            itemsCollectionView.register(R.nib.campaignsHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - PROPERTIES -
    
    private let campaignDetailVM = CampaignDetailViewModel()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    var campaignData: HomeCampaignData?
    private var arrayOfProducts: [OfferList] = []
    private var arrayOfSearchProducts: [OfferList] = []
    private var isLoading: Bool = false
    private var isSearching: Bool = false
    private var mediaURL: String = UserDefault.shared.getMediaURL()
    
    var listDirection : MyListDirection = {
        let mode : MyListDirection = .grid
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        campaignDetailVM.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        getCampaignPrroducts()
        searchTextField.addTarget(self, action: #selector(didSearchingList(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
//        titleLbl.text = PisiffikStrings.campaignProducts()
        titleLbl.text = ""
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getCampaignPrroducts(){
        guard let campaignID = self.campaignData?.id else {return}
        self.searchTextField.isHidden = true
        if !Network.isAvailable{
            self.itemsCollectionView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                let request = CampaignDetailRequest(campaign_id: campaignID)
                self.campaignDetailVM.getCampaignsProducts(with: request)
            }
            self.itemsCollectionView.reloadData()
        }else{
            self.isLoading = true
            let request = CampaignDetailRequest(campaign_id: campaignID)
            self.campaignDetailVM.getCampaignsProducts(with: request)
        }
        
    }
    
    private func navigateToProductDetailVC(offerId: Int,offerData: OfferList){
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = offerData
        offerDetailVC.offerID = offerId
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didSearchingList(_ textField: UITextField){
        if let text = textField.text{
            if text.isEmpty{
                isSearching = false
                textField.text = ""
                self.itemsCollectionView.reloadData()
            }else{
                arrayOfSearchProducts = arrayOfProducts.filter({$0.name?.localizedCaseInsensitiveContains(text) ?? false})
                isSearching = true
                self.itemsCollectionView.reloadData()
            }
        }else{
            isSearching = false
            textField.text = ""
            self.itemsCollectionView.reloadData()
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapShoppingListBtn(_ sender: SYBadgeButton){
        sender.showAnimation {
            if Network.isAvailable{
                guard let myShoppingListVC = R.storyboard.homeSB.myShoppingListVC() else {return}
                self.push(controller: myShoppingListVC, hideBar: true, animated: true)
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    
}

//MARK: - EXTENSION FOR CAMPAIGN DETAIL VIEWMODEL DELEGATES -

extension CampaignDetailVC: CampaignDetailViewModelDelegate{
    
    func didReceiveCampaignProducts(response: CampaignDetailResponse) {
        isLoading = false
        isSearching = false
        self.arrayOfProducts.removeAll()
        self.arrayOfSearchProducts.removeAll()
        if let products = response.data?.item,
           let title = response.data?.campaign?.name{
            self.arrayOfProducts = products
            self.titleLbl.text = title
        }
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
            self?.searchTextField.isHidden = false
        }
    }
    
    func didReceiveCampaignProductsResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        isSearching = false
        self.arrayOfProducts.removeAll()
        self.arrayOfSearchProducts.removeAll()
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        isSearching = false
        self.itemsCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        isSearching = false
        if type == APIType.homeAPI{
            self.itemsCollectionView.reloadData()
            self.itemsCollectionView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                
            }
        }
    }
    
}


//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension CampaignDetailVC: AddPisiffikItemToCartViewModelDelegate{
    
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

extension CampaignDetailVC: PisiffikItemDetailProtocol{
    
    func didPisiffikItem(isFavorite: Int,by id: Int){
        if isSearching{
            guard let index = self.arrayOfProducts.firstIndex(where: {$0.id == id}),
                  let searchIndex = self.arrayOfProducts.firstIndex(where: {$0.id == id}) else {return}
            self.arrayOfProducts[index].isFavorite = isFavorite
            self.arrayOfSearchProducts[searchIndex].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
        }else{
            guard let index = self.arrayOfProducts.firstIndex(where: {$0.id == id}) else {return}
            self.arrayOfProducts[index].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension CampaignDetailVC: AddToFavoriteViewModelDelegate{
    
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        if isSearching{
            guard let index = self.arrayOfProducts.firstIndex(where: {$0.id == self.arrayOfSearchProducts[indexPath].id}) else {return}
            self.arrayOfProducts[index].isFavorite = isFavorite
            self.arrayOfSearchProducts[indexPath].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
        }else{
            self.arrayOfProducts[indexPath].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
        }
    }
    
    func didFailToFoodItemToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension CampaignDetailVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        if let isFavorite = response.data?.isFavorite{
            if isSearching{
                guard let index = self.arrayOfProducts.firstIndex(where: {$0.id == self.arrayOfSearchProducts[indexPath].id}) else {return}
                self.arrayOfProducts[index].isFavorite = isFavorite
                self.arrayOfSearchProducts[indexPath].isFavorite = isFavorite
                DispatchQueue.main.async { [weak self] in
                    self?.itemsCollectionView.reloadData()
                }
            }else{
                self.arrayOfProducts[indexPath].isFavorite = isFavorite
                DispatchQueue.main.async { [weak self] in
                    self?.itemsCollectionView.reloadData()
                }
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


//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension CampaignDetailVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 20 : isSearching ? self.arrayOfSearchProducts.count : self.arrayOfProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listDirection{
        case .grid:
            if isSearching{
                return configureSearchGridCell(at: indexPath)
            }else{
                return configureGridCell(at: indexPath)
            }
        case .list:
            if isSearching{
                return configureSearchListCell(at: indexPath)
            }else{
                return configureListCell(at: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        if isSearching{
            guard let offerID = self.arrayOfSearchProducts[indexPath.row].id else {return}
            let offerData = self.arrayOfSearchProducts[indexPath.row]
            self.navigateToProductDetailVC(offerId: offerID, offerData: offerData)
        }else{
            guard let offerID = self.arrayOfProducts[indexPath.row].id else {return}
            let offerData = self.arrayOfProducts[indexPath.row]
            self.navigateToProductDetailVC(offerId: offerID, offerData: offerData)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.itemsCollectionView.frame.size)
        switch listDirection{
        case .grid:
            if UIDevice().userInterfaceIdiom == .phone{
                return CGSize(width: ((size.width - 10) / 2), height: 260.0)
            }else{
                return CGSize(width: ((size.width - 20) / 4), height: 275.0)
            }
        case .list:
            return CGSize(width: (size.width), height: 140.0)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return configureItemsHeader(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.itemsCollectionView.frame.size.width
        if UIDevice().userInterfaceIdiom == .pad{
            //690.0
            return CGSize(width: width, height: 910.0)
        }else{
            //320.0
            return CGSize(width: width, height: 380.0)
        }
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW CELLS METHOD -

extension CampaignDetailVC{
    
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
            
            if let isFavorite = offer.isFavorite{
                if isFavorite > 0{
                    cell.favoriteBtn.isSelected = true
                }else{
                    cell.favoriteBtn.isSelected = false
                }
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
                        guard let offerID = self?.arrayOfProducts[indexPath.row].id,
                              let offerItemID = self?.arrayOfProducts[indexPath.row].offerItemId else {return}
                        let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                        self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
        }
        
        return cell
    }
    
    private func configureSearchListCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .personalOfferListCell, for: indexPath) as! PersonalOfferListCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let offer = self.arrayOfSearchProducts[indexPath.row]
            
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
            
            if let isFavorite = offer.isFavorite{
                if isFavorite > 0{
                    cell.favoriteBtn.isSelected = true
                }else{
                    cell.favoriteBtn.isSelected = false
                }
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        if let isFavorite = offer.isFavorite{
                            let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfSearchProducts[indexPath.row].id, offerItemID: self?.arrayOfSearchProducts[indexPath.row].offerItemId)
                            if isFavorite == 0{
                                self?.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: indexPath.row)
                            }else{
                                self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                                self?.postUnfavoriteNotification(id: self?.arrayOfSearchProducts[indexPath.row].id ?? 0, isFavorite: 0)
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
                        guard let offerID = self?.arrayOfSearchProducts[indexPath.row].id,
                              let offerItemID = self?.arrayOfSearchProducts[indexPath.row].offerItemId else {return}
                        let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                        self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
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
            
            if let isFavorite = offer.isFavorite{
                if isFavorite > 0{
                    cell.favoriteBtn.isSelected = true
                }else{
                    cell.favoriteBtn.isSelected = false
                }
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
                if Network.isAvailable{
                    if self?.isLoading == false{
                        guard let offerID = self?.arrayOfProducts[indexPath.row].id,
                              let offerItemID = self?.arrayOfProducts[indexPath.row].offerItemId else {return}
                        let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                        self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
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
    
    private func configureSearchGridCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .homeOfferCollectionCell, for: indexPath) as! HomeOfferCollectionCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let offer = self.arrayOfSearchProducts[indexPath.row]
            
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
            
            if let isFavorite = offer.isFavorite{
                if isFavorite > 0{
                    cell.favoriteBtn.isSelected = true
                }else{
                    cell.favoriteBtn.isSelected = false
                }
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if let isFavorite = offer.isFavorite{
                        let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfSearchProducts[indexPath.row].id,offerItemID: self?.arrayOfSearchProducts[indexPath.row].offerItemId)
                        if isFavorite == 0{
                            self?.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: indexPath.row)
                        }else{
                            self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                            self?.postUnfavoriteNotification(id: self?.arrayOfSearchProducts[indexPath.row].id ?? 0, isFavorite: 0)
                        }
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        guard let offerID = self?.arrayOfSearchProducts[indexPath.row].id,
                              let offerItemID = self?.arrayOfSearchProducts[indexPath.row].offerItemId else {return}
                        let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
                        self?.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
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


//MARK: - EXTENSION FOR COLLECTION HEADER VIEW -

extension CampaignDetailVC{
    
    private func configureItemsHeader(_ indexPath: IndexPath) -> UICollectionReusableView{
        let header = itemsCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .campaignsHeaderView, for: indexPath) as! CampaignsHeaderView
        
        if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.campaignData?.banner ?? "")"){
            header.campaignImageView.kf.indicatorType = .activity
            header.campaignImageView.kf.setImage(with: imageURL)
        }
        
        let customType = ActiveType.custom(pattern: "\(PisiffikStrings.items())")
        header.itemsLbl.enabledTypes = [customType]
        header.itemsLbl.customColor[customType] = R.color.textBlackColor()
        
        header.itemsLbl.text = "\(PisiffikStrings.items()) (\(self.arrayOfProducts.count))"
        
        header.gridBtn.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            if (self.isLoading) {return}
            header.gridBtn.isSelected = true
            header.listBtn.isSelected = false
            self.listDirection = .grid
            self.itemsCollectionView.reloadData()
        }
        
        header.listBtn.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            if (self.isLoading) {return}
            header.gridBtn.isSelected = false
            header.listBtn.isSelected = true
            self.listDirection = .list
            self.itemsCollectionView.reloadData()
        }
    
        return header
    }
    
}

//MARK: - EXTENSION FOR POST NOTIFICATION -

extension CampaignDetailVC{
    
    private func postUnfavoriteNotification(id: Int,isFavorite: Int){
        let userInfo : [String : Int] = [.foodItemID: id,.isFavorite: isFavorite]
        NotificationCenter.default.post(name: .foodItemFavoriteListUpdate, object: nil, userInfo: userInfo)
    }
    
    private func addNewShoppingListNotification(){
        let counter = String(UserDefault.shared.getShoppingListCount())
        let userInfo : [String : String] = [.counter: counter]
        NotificationCenter.default.post(name: .myFavoritesShoppingListCounter, object: nil, userInfo: userInfo)
        self.shoppingListBtn.badgeValue = String(UserDefault.shared.getShoppingListCount())
    }
    
    private func removeNewShoppingListNotification(){
        let counter = String(UserDefault.shared.getShoppingListCount())
        let userInfo : [String : String] = [.counter: counter]
        NotificationCenter.default.post(name: .myFavoritesShoppingListCounter, object: nil, userInfo: userInfo)
    }
    
}
