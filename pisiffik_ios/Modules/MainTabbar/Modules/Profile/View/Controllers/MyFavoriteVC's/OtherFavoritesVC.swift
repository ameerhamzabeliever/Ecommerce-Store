//
//  OtherFavoritesVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class OtherFavoritesVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!{
        didSet{
            favoritesCollectionView.delegate = self
            favoritesCollectionView.dataSource = self
            favoritesCollectionView.reloadData()
            favoritesCollectionView.register(R.nib.favoritesListCell)
            favoritesCollectionView.register(R.nib.favoritesGridCell)
//            favoritesCollectionView.register(R.nib.homeOfferCollectionCell)
            favoritesCollectionView.register(R.nib.favoritesHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        }
    }
    
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    
    //MARK: - PROPERTIES -
    
    private var listViewModel = OtherFavoriteItemViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var isLoading : Bool = false
    private var isSearching : Bool = false
    private var arrayOfItems : [OfferList] = []
    private var searchingList : [OfferList] = []
    
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
        listViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        getOtherFavoriteItemList()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        searchBar.placeholder = PisiffikStrings.search()
    }
    
    func setUI() {
        searchBar.addTarget(self, action: #selector(didSearchingList(_:)), for: .editingChanged)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getOtherFavoriteItemList(){
        
        self.searchBarBackView.isHidden = true
        if !Network.isAvailable{
            self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.listViewModel.getOtherFavoriteItemList()
            }
            self.favoritesCollectionView.reloadData()
        }else{
            self.isLoading = true
            self.listViewModel.getOtherFavoriteItemList()
        }
        
    }
    
    private func navigateToProductDetailVC(){
        guard let productDetailVC = R.storyboard.homeSB.productDetailVC() else {return}
        self.push(controller: productDetailVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    
    @objc func didSearchingList(_ textField: UITextField){
        if let text = textField.text{
            if text.isEmpty{
                isSearching = false
                textField.text = ""
                self.favoritesCollectionView.reloadData()
            }else{
                searchingList = arrayOfItems.filter({$0.name?.localizedCaseInsensitiveContains(text) ?? false})
                isSearching = true
                if searchingList.isEmpty{
                    self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                }
                self.favoritesCollectionView.reloadData()
            }
        }else{
            isSearching = false
            textField.text = ""
            self.favoritesCollectionView.reloadData()
        }
    }
    
}


//MARK: - EXTENSION FOR OtherFavoriteItemViewModel DELEGATES -

extension OtherFavoritesVC: OtherFavoriteItemViewModelDelegate{
    
    func didReceiveOtherFavoriteItemList(response: OtherFavoriteItemResponse) {
        isLoading = false
        if let list = response.data?.products{
            if !list.isEmpty{
                for item in list{
                    if !self.arrayOfItems.contains(where: {$0.id == item.id}){
                        if item.isFood == 0{
                            self.arrayOfItems.append(item)
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                    self?.searchBarBackView.isHidden = false
                }
            }else{
                self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.favoritesCollectionView.reloadData()
            }
        }
    }
    
    func didReceiveOtherFavoriteItemListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.favoritesCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.favoritesCollectionView.reloadData()
        self.favoritesCollectionView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.getOtherFavoriteItemList()
        }
    }
    
}


//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension OtherFavoritesVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveProductFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        
    }
    
    func didFailToRemoveProductFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension OtherFavoritesVC: AddPisiffikItemToCartViewModelDelegate{
    
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

//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension OtherFavoritesVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 20 : isSearching ? self.searchingList.count : self.arrayOfItems.count
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
                return configureSearchListCell(indexPath)
            }else{
                return configureListCell(indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.navigateToProductDetailVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.favoritesCollectionView.frame.width - 10)
        switch listDirection{
        case .grid:
            if UIDevice().userInterfaceIdiom == .phone{
                return CGSize(width: width / 2, height: 265.0)
            }else{
                return CGSize(width: width / 4, height: 275.0)
            }
        case .list:
            return CGSize(width: (width), height: 150.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return configureFavoritesHeader(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.favoritesCollectionView.frame.size.width
        if self.arrayOfItems.isEmpty{
            return CGSize(width: width, height: 0.0)
        }else{
            return CGSize(width: width, height: 50.0)
        }
    }
    
}


//MARK: - EXTENSION FOR FAVORITES CELLS -

extension OtherFavoritesVC{
    
    private func configureListCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesListCell, for: indexPath) as! FavoritesListCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let offer = self.arrayOfItems[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.itemNameLbl.text = offer.name
            
            if let isMember = offer.isMember,
               isMember == 1{
                cell.currentPriceLbl.text = "\(offer.salePrice ?? 0.0) \(offer.currency ?? "")"
                cell.discountedPriceLbl.text = ""
            }else{
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
            
            if let isMember = offer.isMember,
            isMember == 1{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.darkGrayColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = false
                cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(offer.afterDiscountPrice ?? 0.0) \(offer.currency ?? "")"
            }else{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.lightGreenColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = true
                cell.rebateLbl.text = ""
            }
            
            if let expireIn = offer.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = true
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
                        let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfItems[indexPath.row].id, offerItemID: self?.arrayOfItems[indexPath.row].offerItemId)
                        self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                        self?.postUnfavoriteNotification(id: self?.arrayOfItems[indexPath.row].id ?? 0, isFavorite: 0)
                        self?.arrayOfItems.remove(at: indexPath.row)
                        if self?.arrayOfItems.isEmpty == true{
                            self?.searchBarBackView.isHidden = true
                            self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                            self?.favoritesCollectionView.reloadData()
                        }else{
                            self?.favoritesCollectionView.reloadData()
                        }
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
            cell.cartBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        if Network.isAvailable{
                            guard let offerID = self?.arrayOfItems[indexPath.row].id,
                                  let offerItemID = self?.arrayOfItems[indexPath.row].offerItemId else {return}
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
    
    
    private func configureSearchListCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesListCell, for: indexPath) as! FavoritesListCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let offer = self.searchingList[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.itemNameLbl.text = offer.name
            
            if let isMember = offer.isMember,
               isMember == 1{
                cell.currentPriceLbl.text = "\(offer.salePrice ?? 0.0) \(offer.currency ?? "")"
                cell.discountedPriceLbl.text = ""
            }else{
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
            
            if let isMember = offer.isMember,
            isMember == 1{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.darkGrayColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = false
                cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(offer.afterDiscountPrice ?? 0.0) \(offer.currency ?? "")"
            }else{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.lightGreenColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = true
                cell.rebateLbl.text = ""
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
                        let request = AddFoodItemToFavoriteRequest(productID: self?.searchingList[indexPath.row].id, offerItemID: self?.searchingList[indexPath.row].offerItemId)
                        self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                        self?.postUnfavoriteNotification(id: self?.searchingList[indexPath.row].id ?? 0, isFavorite: 0)
                        if self?.isSearching == true{
                            if let offers = self?.arrayOfItems{
                                if let index = offers.firstIndex(where: {$0.id == self?.searchingList[indexPath.row].id}){
                                    self?.arrayOfItems.remove(at: index)
                                }
                            }
                            self?.searchingList.remove(at: indexPath.row)
                            
                            if self?.searchingList.isEmpty == true{
                                self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                                self?.favoritesCollectionView.reloadData()
                            }else{
                                self?.favoritesCollectionView.reloadData()
                            }
                            
                        }else{
                            
                            self?.arrayOfItems.remove(at: indexPath.row)
                            if self?.arrayOfItems.isEmpty == true{
                                self?.searchBarBackView.isHidden = true
                                self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                                self?.favoritesCollectionView.reloadData()
                            }else{
                                self?.favoritesCollectionView.reloadData()
                            }
                            
                        }
                    }
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
            cell.cartBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    if self?.isLoading == false{
                        if Network.isAvailable{
                            guard let offerID = self?.searchingList[indexPath.row].id,
                                  let offerItemID = self?.searchingList[indexPath.row].offerItemId else {return}
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
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesGridCell, for: indexPath) as! FavoritesGridCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let item = self.arrayOfItems[indexPath.row]
            
            if let images = item.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.titleLbl.text = item.name
            
            if let isMember = item.isMember,
               isMember == 1{
                cell.priceLbl.text = "\(item.salePrice ?? 0.0) \(item.currency ?? "")"
                cell.discountPrice.text = ""
            }else{
                if let isDiscounted = item.isDiscountEnabled,
                   let salePrice = item.salePrice,
                   let currency = item.currency{
                    if isDiscounted{
                        cell.discountPrice.isHidden = false
                        cell.discountPrice.attributedText = "\(salePrice) \(currency)".strikeThrough()
                        cell.priceLbl.text = "\(item.afterDiscountPrice ?? 0) \(currency)"
                    }else{
                        cell.discountPrice.isHidden = true
                        cell.priceLbl.text = "\(salePrice) \(currency)"
                    }
                }else{
                    cell.discountPrice.isHidden = true
                    cell.priceLbl.text = "\(item.salePrice ?? 0) \(item.currency ?? "")"
                }
            }
            
            if let points = item.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = true
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            if let isMember = item.isMember,
            isMember == 1{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.darkGrayColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = false
                cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(item.afterDiscountPrice ?? 0.0) \(item.currency ?? "")"
            }else{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.lightGreenColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = true
                cell.rebateLbl.text = ""
            }
            
            if let expireIn = item.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = true
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = item.isFavorite,
               isFavorite > 0{
                cell.favoriteBtn.isSelected = true
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    let request = AddFoodItemToFavoriteRequest(productID: self?.arrayOfItems[indexPath.row].id,offerItemID: self?.arrayOfItems[indexPath.row].offerItemId)
                    self?.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                    self?.postUnfavoriteNotification(id: self?.arrayOfItems[indexPath.row].id ?? 0, isFavorite: 0)
                    self?.arrayOfItems.remove(at: indexPath.row)
                    
                    if self?.arrayOfItems.isEmpty == true{
                        self?.searchBarBackView.isHidden = true
                        self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                        self?.favoritesCollectionView.reloadData()
                    }else{
                        self?.favoritesCollectionView.reloadData()
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if Network.isAvailable{
                        guard let offerID = self?.arrayOfItems[indexPath.row].id,
                              let offerItemID = self?.arrayOfItems[indexPath.row].offerItemId else {return}
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
    
    private func configureSearchGridCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesGridCell, for: indexPath) as! FavoritesGridCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let item = self.searchingList[indexPath.row]
            
            if let images = item.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.titleLbl.text = item.name
            
            if let isMember = item.isMember,
               isMember == 1{
                cell.priceLbl.text = "\(item.salePrice ?? 0.0) \(item.currency ?? "")"
                cell.discountPrice.text = ""
            }else{
                if let isDiscounted = item.isDiscountEnabled,
                   let salePrice = item.salePrice,
                   let currency = item.currency{
                    if isDiscounted{
                        cell.discountPrice.isHidden = false
                        cell.discountPrice.attributedText = "\(salePrice) \(currency)".strikeThrough()
                        cell.priceLbl.text = "\(item.afterDiscountPrice ?? 0) \(currency)"
                    }else{
                        cell.discountPrice.isHidden = true
                        cell.discountPrice.text = ""
                        cell.priceLbl.text = "\(salePrice) \(currency)"
                    }
                }else{
                    cell.discountPrice.isHidden = true
                    cell.discountPrice.text = ""
                    cell.priceLbl.text = "\(item.salePrice ?? 0) \(item.currency ?? "")"
                }
            }
            
            if let points = item.points{
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
            
            if let isMember = item.isMember,
            isMember == 1{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.darkGrayColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = false
                cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(item.afterDiscountPrice ?? 0.0) \(item.currency ?? "")"
            }else{
                cell.pointsLbl.font = Fonts.boldFontsSize10
                cell.pointsLbl.textColor = R.color.lightGreenColor()
                cell.rebateLbl.font = Fonts.semiBoldFontsSize14
                cell.rebateLbl.isHidden = true
                cell.rebateLbl.text = ""
            }
            
            if let expireIn = item.expiresIn{
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
            
            if let isFavorite = item.isFavorite,
               isFavorite > 0{
                cell.favoriteBtn.isSelected = true
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    let request = AddProductToFavoriteRequest(productID: self?.searchingList[indexPath.row].id)
                    self?.unFavoriteViewModel.removeProductFromFavoriteList(request: request, indexPath: indexPath.row)
                    if self?.isSearching == true{
                        if let items = self?.arrayOfItems{
                            if let index = items.firstIndex(where: {$0.id == self?.searchingList[indexPath.row].id}){
                                self?.arrayOfItems.remove(at: index)
                            }
                        }
                        self?.searchingList.remove(at: indexPath.row)
                        
                        if self?.searchingList.isEmpty == true{
                            self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                            self?.favoritesCollectionView.reloadData()
                        }else{
                            self?.favoritesCollectionView.reloadData()
                        }
                        
                    }else{
                        
                        self?.arrayOfItems.remove(at: indexPath.row)
                        if self?.arrayOfItems.isEmpty == true{
                            self?.searchBarBackView.isHidden = true
                            self?.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                            self?.favoritesCollectionView.reloadData()
                        }else{
                            self?.favoritesCollectionView.reloadData()
                        }
                        
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    
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
    
    
    
    fileprivate func configureFavoritesHeader(_ indexPath: IndexPath) -> UICollectionReusableView{
        let header = favoritesCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .favoritesHeaderView, for: indexPath) as! FavoritesHeaderView
        
        let customType = ActiveType.custom(pattern: "\(PisiffikStrings.favorites())")
        header.myFavoritesLbl.enabledTypes = [customType]
        header.myFavoritesLbl.customColor[customType] = R.color.textBlackColor()
        if isSearching{
            header.myFavoritesLbl.text = "\(PisiffikStrings.favorites()) (\(self.searchingList.count))"
        }else{
            header.myFavoritesLbl.text = "\(PisiffikStrings.favorites()) (\(self.arrayOfItems.count))"
        }
        
        header.gridBtn.addTapGestureRecognizer { [weak self] in
            header.gridBtn.isSelected = true
            header.listBtn.isSelected = false
            self?.listDirection = .grid
            self?.favoritesCollectionView.reloadData()
        }
        
        header.listBtn.addTapGestureRecognizer { [weak self] in
            header.gridBtn.isSelected = false
            header.listBtn.isSelected = true
            self?.listDirection = .list
            self?.favoritesCollectionView.reloadData()
        }
    
        return header
    }
    
}

//MARK: - EXTENSION FOR POST NOTIFICATION -

extension OtherFavoritesVC{
    
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
