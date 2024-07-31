//
//  HomeVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SYBadgeButton
import SkeletonView

class HomeVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var homeTableView: UITableView!{
        didSet{
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.register(R.nib.pointsCell)
            homeTableView.register(R.nib.currentOfferCell)
            homeTableView.register(R.nib.currentCampaignsCell)
            homeTableView.register(R.nib.recipesCell)
        }
    }
    @IBOutlet weak var cartListBtn: SYBadgeButton!
    @IBOutlet weak var notificationBtn: SYBadgeButton!
    @IBOutlet weak var cartBtn: SYBadgeButton!
    
    //MARK: - PROPERTIES -
    
    private var homeViewModel: HomeViewModel = HomeViewModel()
    private var homeResponse: HomeResponseData = HomeResponseData()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    private var isLoading : Bool = false
    private let refreshControl = UIRefreshControl()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        observers()
        addObservers()
        self.homeViewModel.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        getHomeResponse()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
        updateHomeIconCounter()
    }
    
    deinit{
        removeObservers()
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        guard let currentUser = DBUserManagerRepository().getUser(),
              let fullName = currentUser.fullName
        else {
            return
        }
        titleLbl.text = PisiffikStrings.hi() + " " + fullName
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 1
        refreshControl.attributedTitle = NSAttributedString(string: "")
        homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefreshControl(_:)), for: .valueChanged)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    func updateHomeIconCounter(){
        notificationBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getNotificationBadgeCount())
        cartListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
//        cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getCartListCount())
    }
    
    private func getHomeResponse(){
        if !Network.isAvailable{
            self.homeTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.homeViewModel.homeRequest()
            }
        }else{
            self.isLoading = true
            self.homeViewModel.homeRequest()
        }
    }
    
    private func navigateToMyProfileVC(){
        guard let myProfileVC = R.storyboard.profileSB.myProfileVC() else {return}
        self.push(controller: myProfileVC, hideBar: true, animated: true)
    }
    
    @objc
    private func didRefreshControl(_ sender: UIRefreshControl){
        self.refreshControl.endRefreshing()
        if !isLoading{
            if Network.isAvailable{
                self.isLoading = true
                DispatchQueue.main.async { [weak self] in
                    self?.homeTableView.reloadData()
                }
                self.homeViewModel.homeRequest()
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapPointsViewDetailBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let pointsVC = R.storyboard.profileSB.myPointsVC() else {return}
            self.push(controller: pointsVC, hideBar: true, animated: true)
        }
    }
    
    @objc func didTapOffersSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let myOfferAndBenefitVC = R.storyboard.homeOffersSB.myOfferAndBenefitVC() else {return}
            myOfferAndBenefitVC.mode = .fromHome
            self.push(controller: myOfferAndBenefitVC, hideBar: true, animated: true)
        }
    }
    
    @objc func didTapCampaignSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let currentCampaignsVC = R.storyboard.homeSB.currentCampaingsVC() else {return}
            self.push(controller: currentCampaignsVC, hideBar: true, animated: true)
        }
    }
    
    @objc func didTapRecipesSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let recipesVC = R.storyboard.homeSB.recipesVC() else {return}
            self.push(controller: recipesVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapProfileBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigateToMyProfileVC()
        }
    }
    
    @IBAction func didTapCartBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            guard let myCartVC = R.storyboard.homeSB.myCartVC() else {return}
            self.push(controller: myCartVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapCartListBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            if Network.isAvailable{
                guard let myShoppingListVC = R.storyboard.homeSB.myShoppingListVC() else {return}
                self.push(controller: myShoppingListVC, hideBar: true, animated: true)
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    
    @IBAction func didTapNotificationBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            guard let notificationsVC = R.storyboard.homeSB.notificationsVC() else {return}
            self.push(controller: notificationsVC, hideBar: true, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension HomeVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.isLoading ? 1 : Network.isAvailable ? 1 : 0
        case 1:
            return self.isLoading ? 1 : self.homeResponse.currentOffers?.count ?? 0 > 0 ? 1 : 0
        case 2:
            return self.isLoading ? 1 : self.homeResponse.campaigns?.count ?? 0 > 0 ? 1 : 0
        case 3:
            return self.isLoading ? 1 : self.homeResponse.recipies?.count ?? 0 > 0 ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            return configurePointsCell(indexPath)
        case 1:
            return configureCurrentOfferCell(indexPath)
        case 2:
            return configureCurrentCampaignsCell(indexPath)
        case 3:
            return configureReceipesCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}

//MARK: - EXTENSION FOR HOME CELLS -

extension HomeVC{
    
    fileprivate func configurePointsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = homeTableView.dequeueReusableCell(withIdentifier: .pointsCell, for: indexPath) as! PointsCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            if let points = self.homeResponse.points{
                
                if points > Constants.maxLoyalityPoints {
                    cell.pointsLbl.text = "\(Constants.maxLoyalityPoints)+"
                }else{
                    cell.pointsLbl.text = "\(points)"
                }
                
            }else{
                cell.pointsLbl.text = "\(0)"
            }
            cell.pointOverviewLbl.text = PisiffikStrings.pointsOverview()
            cell.viewDetailBtn.setTitle(PisiffikStrings.viewDetail(), for: .normal)
            cell.viewDetailBtn.addTarget(self, action: #selector(didTapPointsViewDetailBtn(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    fileprivate func configureCurrentOfferCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = homeTableView.dequeueReusableCell(withIdentifier: .currentOfferCell, for: indexPath) as! CurrentOfferCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
        
            if let offerList = self.homeResponse.currentOffers{
                cell.offerList = offerList
                cell.titleLbl.text = "\(PisiffikStrings.currentOffers()) (\(self.homeResponse.totalCurrentOffersCount ?? offerList.count))"
            }
            cell.seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            cell.seeAllBtn.addTarget(self, action: #selector(didTapOffersSeeAllBtn(_:)), for: .touchUpInside)
            cell.delegate = self
        }
        
        return cell
    }
    
    fileprivate func configureCurrentCampaignsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = homeTableView.dequeueReusableCell(withIdentifier: .currentCampaignsCell, for: indexPath) as! CurrentCampaignsCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            cell.delegate = self
            if let campaings = self.homeResponse.campaigns{
                cell.arrayOfCampaings = campaings
                cell.titleLbl.text = "\(PisiffikStrings.currentCampaigns()) (\(self.homeResponse.totalCampaingCount ?? campaings.count))"
            }
            cell.seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            cell.seeAllBtn.addTarget(self, action: #selector(didTapCampaignSeeAllBtn(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    fileprivate func configureReceipesCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = homeTableView.dequeueReusableCell(withIdentifier: .recipesCell, for: indexPath) as! RecipesCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            cell.titleLbl.text = PisiffikStrings.recipes()
            if let recipies = self.homeResponse.recipies{
                cell.arrayOfRecipies = recipies
            }
            cell.seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            cell.seeAllBtn.addTarget(self, action: #selector(didTapRecipesSeeAllBtn(_:)), for: .touchUpInside)
            cell.delegate = self
        }
        
        return cell
    }
    
}

//MARK: - EXTENSION FOR HOME VIEW MODEL DELEGATES -

extension HomeVC: HomeViewModelDelegate{
    
    func didReceiveHome(response: HomeResponse) {
        self.isLoading = false
        if let data = response.data{
            self.homeResponse = data
            if let shoppingListCounter = data.shoppingListCount{
                UserDefault.shared.saveShoppingList(count: shoppingListCounter)
            }
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
                self?.updateHomeIconCounter()
            }
        }
        UserDefault.shared.saveUserCurrent(points: response.data?.points ?? 0)
        if let notificationCount = response.data?.notificationCount{
            let count = notificationCount - UserDefault.shared.getNotificationsID().count
            UserDefault.shared.saveNotificationBadge(count: count)
            notificationBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getNotificationBadgeCount())
        }
    }
    
    func didReceiveHomeResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.homeTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.homeTableView.reloadData()
            self.homeTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.homeViewModel.homeRequest()
            }
        }
    }
    
}

//MARK: - EXTENSION FOR CURRENT OFFER CELL DELEGATES -

extension HomeVC: CurrentOfferDelegates{
    
    func didTapCurrentOffersCell(at indexPath: IndexPath) {
        guard let offerData = self.homeResponse.currentOffers?[indexPath.row],
              let offerID = self.homeResponse.currentOffers?[indexPath.row].id else {return}
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = offerData
        offerDetailVC.offerID = offerID
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    func didTapCurrentOfferFavoriteBtn(at indexPath: IndexPath) {
        if Network.isAvailable{
            guard let productID = self.homeResponse.currentOffers?[indexPath.row].id,
                  let offerItemID = self.homeResponse.currentOffers?[indexPath.row].offerItemId else {return}
            let request = AddFoodItemToFavoriteRequest(productID: productID, offerItemID: offerItemID)
            if let isFavorite = self.homeResponse.currentOffers?[indexPath.row].isFavorite{
                if isFavorite == 0{
                    self.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: indexPath.row)
                }else{
                    self.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: indexPath.row)
                }
            }
        }else{
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
            }
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
        
    }
    
    func didTapCurrentOfferCartListBtn(at indexPath: IndexPath) {
        if Network.isAvailable{
            guard let productID = self.homeResponse.currentOffers?[indexPath.row].id,
                  let offerrItemID = self.homeResponse.currentOffers?[indexPath.row].offerItemId else {return}
            let request = AddPisiffikProductRequest(variantID: productID, offerItemID: offerrItemID, uomQuantity: 1)
            self.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: indexPath.row)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
}

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension HomeVC: AddToFavoriteViewModelDelegate{
    
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.homeResponse.recipies?[indexPath].is_favorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToAddRecipeToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.homeResponse.currentOffers?[indexPath].isFavorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
    func didFailToFoodItemToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension HomeVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.homeResponse.recipies?[indexPath].is_favorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        self.homeResponse.currentOffers?[indexPath].isFavorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension HomeVC: AddPisiffikItemToCartViewModelDelegate{
    
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

//MARK: - EXTENSION FOR OFFER DETAIL DELEGATES -

extension HomeVC: PisiffikItemDetailProtocol{
    
    func didPisiffikItem(isFavorite: Int,by id: Int){
        guard let index = self.homeResponse.currentOffers?.firstIndex(where: {$0.id == id}) else {return}
        self.homeResponse.currentOffers?[index].isFavorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
}


//MARK: - EXTENSION FOR RECIPES CELL DELEGATES -

extension HomeVC: RecipesCellDelagtes{
    
    func didTapOnRecipeCell(at indexPath: IndexPath,id: Int) {
        guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
        recipeDetailVC.currentTitle = self.homeResponse.recipies?[indexPath.row].recipe_type ?? PisiffikStrings.recipes()
        recipeDetailVC.currentID = id
        recipeDetailVC.delegate = self
        self.push(controller: recipeDetailVC, hideBar: true, animated: true)
    }
    
    func didTapOnRecipeFavoriteBtn(at indexPath: IndexPath,id: Int) {
        if let recipe = self.homeResponse.recipies?[indexPath.row]{
            guard let recipeID = recipe.id else {return}
            let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
            if recipe.is_favorite == 0{
                self.favoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: indexPath.row)
            }else{
                self.unFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: indexPath.row)
            }
        }
    }
    
}

//MARK: - EXTENSION FOR RECIPE FAVORITE DELEGATES -

extension HomeVC: RecipeFavoritesDelegates{
    
    func didFavoriteRecipeBy(id: Int, isFavorite: Int, at index: Int,indexPath: IndexPath?) {
        guard let index = self.homeResponse.recipies?.firstIndex(where: {$0.id == id}) else {return}
        self.homeResponse.recipies?[index].is_favorite = isFavorite
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
}


//MARK: - EXTENSION FOR CAMPAIGN CELL DELEGATES -

extension HomeVC: CurrentCampaignCellDelegate{
    
    func didTapCampaign(at index: IndexPath) {
        guard let campaigns = self.homeResponse.campaigns,
              !campaigns.isEmpty else {return}
        guard let campaignDetailVC = R.storyboard.homeSB.campaignDetailVC() else {return}
        campaignDetailVC.campaignData = campaigns[index.row]
        self.push(controller: campaignDetailVC, hideBar: true, animated: true)
    }
    
}



//MARK: - EXTENSION FOR OBERSERVER FUNC -

extension HomeVC{
    
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didFoodItemListFavoriteUpdateNotificationReceived(_:)), name: .foodItemFavoriteListUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecipeListUpdateNotificationReceived(_:)), name: .recipeFavoriteListUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePushNotification(_:)), name: .pushNotificationReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount(_:)), name: .updateHomeNotificationCount, object: nil)
        UserDefault.shared.saveNewsDetailVC(open: false)
        UserDefault.shared.saveEventDetailVC(open: false)
        UserDefault.shared.saveRecipeDetailVC(open: false)
        UserDefault.shared.saveTicketDetailVC(open: false)
    }
    
    private func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .recipeFavoriteListUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: .foodItemFavoriteListUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: .pushNotificationReceived, object: nil)
        NotificationCenter.default.removeObserver(self, name: .updateHomeNotificationCount, object: nil)
    }
    
}

//MARK: - EXTENDION FOR OBERSERVERS SELECTOR FUNC -

extension HomeVC{
    
    
    @objc private func didFoodItemListFavoriteUpdateNotificationReceived(_ notification: NSNotification){
        if let notificationObj = notification.userInfo as? [String: Any]{
            if let foodItemID = notificationObj[.foodItemID] as? Int,
               let isFavorite = notificationObj[.isFavorite] as? Int,
               let foodItemList = self.homeResponse.currentOffers {
                if foodItemList.contains(where: {$0.id == foodItemID}){
                    if let index = foodItemList.firstIndex(where: {$0.id == foodItemID}){
                        self.homeResponse.currentOffers?[index].isFavorite = isFavorite
                        DispatchQueue.main.async { [weak self] in
                            self?.homeTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didRecipeListUpdateNotificationReceived(_ notification: NSNotification){
        if let notificationObj = notification.userInfo as? [String: Any]{
            if let recipeID = notificationObj[.recipeID] as? Int,
               let isFavorite = notificationObj[.isFavorite] as? Int,
               let recipesList = self.homeResponse.recipies {
                if recipesList.contains(where: {$0.id == recipeID}){
                    if let index = recipesList.firstIndex(where: {$0.id == recipeID}){
                        self.homeResponse.recipies?[index].is_favorite = isFavorite
                        DispatchQueue.main.async { [weak self] in
                            self?.homeTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}


//MARK: - PUSH NOTIFICATION RECEIVED METHOD -

extension HomeVC{
    
    @objc
    private func didReceivePushNotification(_ notification: NSNotification){
        if let notificationObj = notification.userInfo as? [String: Any]{
            if let type = notificationObj[.type] as? String,
               let title = notificationObj[.title] as? String,
               let body = notificationObj[.body] as? String,
               let notificationID = notificationObj[.notificationID] as? String{
                saveNotificationBadgeOnView(notificationID: notificationID)
                if type == NotificationTypes.news{
                    if !UserDefault.shared.isNewsDetailVC(){
                        navigateToNewsDetailVC(jsonStr: notificationObj[.data] as? String)
                    }
                }else if type == NotificationTypes.event{
                    if !UserDefault.shared.isEventDetailVC(){
                        if LocationManager.shared.userDeniedLocation{
                            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDistanceAlertMessage(),cancelBtnHide: false, delegate: self)
                        }else{
                            navigateToEventDetailVC(jsonStr: notificationObj[.data] as? String)
                        }
                    }
                }else if type == NotificationTypes.recipe{
                    if !UserDefault.shared.isRecipeDetailVC(){
                        navigateToRecipeDetailVC(jsonStr: notificationObj[.data] as? String)
                    }
                }else if type == NotificationTypes.message{
                    if !UserDefault.shared.isTicketDetailVC(){
                        navigateToTicketDetailVC(jsonStr: notificationObj[.data] as? String)
                    }
                }else if type == NotificationTypes.general{
                    self.showAlert(title: title, errorMessages: [body])
                }
            }
        }
    }
    
    @objc
    private func updateNotificationCount(_ notification: NSNotification){
        DispatchQueue.main.async { [weak self] in
            self?.notificationBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getNotificationBadgeCount())
        }
    }
    
    private func navigateToNewsDetailVC(jsonStr: String?){
        if let jsonStr = jsonStr{
            if let news = convertJsonStringToModel(jsonStr: jsonStr, type: NewsList.self){
                NewsLocalManager.shared.saveNewsID(id: news.id ?? 0)
                guard let newsDetailVC = R.storyboard.profileSB.newsDetailVC() else {return}
                newsDetailVC.newsObj = news
                self.push(controller: newsDetailVC, hideBar: true, animated: true)
            }
        }
    }
    
    private func navigateToEventDetailVC(jsonStr: String?){
        if let jsonStr = jsonStr{
            if let event = convertJsonStringToModel(jsonStr: jsonStr, type: EventsList.self){
                EventIDLocalManager.shared.saveEventID(id: event.id ?? 0)
                guard let eventDetailVC = R.storyboard.profileSB.eventDetailVC() else {return}
                eventDetailVC.eventID = event.id ?? 0
                eventDetailVC.event = event
                self.push(controller: eventDetailVC, hideBar: true, animated: true)
            }
        }
    }
    
    private func navigateToRecipeDetailVC(jsonStr: String?){
        if let jsonStr = jsonStr{
            if let recipe = convertJsonStringToModel(jsonStr: jsonStr, type: RecipeNotificationData.self){
                guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
                recipeDetailVC.currentTitle = recipe.recipeType ?? PisiffikStrings.recipes()
                recipeDetailVC.currentID = recipe.id ?? 0
                recipeDetailVC.delegate = self
                recipeDetailVC.mode = .byNotifications
                self.push(controller: recipeDetailVC, hideBar: true, animated: true)
            }
        }
    }
    
    private func navigateToTicketDetailVC(jsonStr: String?){
        if let jsonStr = jsonStr{
            if let ticket = convertJsonStringToModel(jsonStr: jsonStr, type: TicketList.self){
                guard let ticketDetailVC = R.storyboard.profileSB.ticketDetailVC() else {return}
                ticketDetailVC.currentTicket = ticket
                self.push(controller: ticketDetailVC, hideBar: true, animated: true)
            }
        }
    }
    
    private func convertJsonStringToModel<T: Decodable>(jsonStr: String,type: T.Type) -> T?{
        let jsonData = Data(jsonStr.utf8)
        let decoder = JSONDecoder()
        do{
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
        }catch{
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    private func saveNotificationBadgeOnView(notificationID: String){
        let id = Int(notificationID) ?? 0
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefault.shared.saveNotificationsID(id: id)
        let badge = (UserDefault.shared.getNotificationBadgeCount())
        UserDefault.shared.saveNotificationBadge(count: badge)
        DispatchQueue.main.async { [weak self] in
            self?.notificationBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getNotificationBadgeCount())
        }
    }
    
}


//MARK: - EXTENSION FOR STORE HELP DELEGATE VC -

extension HomeVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}
