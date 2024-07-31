//
//  OfferVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SYBadgeButton

class OfferVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var offerTableView: UITableView!{
        didSet{
            offerTableView.delegate = self
            offerTableView.dataSource = self
            offerTableView.register(R.nib.offerConceptCell)
            offerTableView.register(R.nib.offerBannerCell)
            offerTableView.register(R.nib.offerNewspaperCell)
            offerTableView.register(R.nib.personalOfferCell)
            offerTableView.register(R.nib.membershipOfferCell)
            offerTableView.register(R.nib.localOfferCell)
            offerTableView.register(R.nib.offerActivitiesCell)
        }
    }
    @IBOutlet weak var cartBtn: SYBadgeButton!
    
    //MARK: - PROPERTIES -
    
    private var offersViewModel = OffersViewModel()
    private var offerEventsViewModel = OfferEventsViewModel()
    private var digitalNewspaperViewModel = OffersNewspaperViewModel()
    private var addToShoppingViewModel = AddPisiffikItemToCartViewModel()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var isLoading: Bool = false
    private var offerEventsData: OfferEventsData = OfferEventsData()
    private var digitalNewspapers: [DigitalNewspaper] = []
    private var mediaURL: String = ""
    private var arrayOfConcepts: [AllOffersConcepts] = []
    private var arrayOfPersonal: [OfferList] = []
    private var arrayOfLocal: [OfferList] = []
    private var arrayOfMembership: [OfferList] = []
    private var selectedConceptID: Int = 2
    private let refreshControl = UIRefreshControl()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        offersViewModel.delegate = self
        offerEventsViewModel.delegate = self
        digitalNewspaperViewModel.delegate = self
        addToShoppingViewModel.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        self.getOfferNewspapers()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.offers()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        offerTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefreshControl(_:)), for: .valueChanged)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func didRefreshControl(_ sender: UIRefreshControl){
        self.refreshControl.endRefreshing()
        if !isLoading{
            if Network.isAvailable{
                self.arrayOfConcepts.removeAll()
                self.selectedConceptID = 2
                self.getOfferNewspapers()
                DispatchQueue.main.async { [weak self] in
                    self?.offerTableView.reloadData()
                }
            }
        }
    }
    
    private func navigateToMyOfferAndBenefitWithSelected(mode: MyOfferAndBenefitMode){
        guard let myOfferAndBenefitVC = R.storyboard.homeOffersSB.myOfferAndBenefitVC() else {return}
        myOfferAndBenefitVC.mode = mode
        self.push(controller: myOfferAndBenefitVC, hideBar: true, animated: true)
    }
    
    private func getOfferNewspapers(){
        if Network.isAvailable{
            isLoading = true
            self.digitalNewspaperViewModel.getDigitalNewspapers()
        }else{
            AlertController.showAlert(title: PisiffikStrings.alert(), message: PisiffikStrings.oopsNoInternetConnection(), inVC: self)
        }
    }
    
    private func getOfferEventsRequest(){
        if Network.isAvailable{
            self.offerEventsViewModel.getOfferEvents()
        }else{
            AlertController.showAlert(title: PisiffikStrings.alert(), message: PisiffikStrings.oopsNoInternetConnection(), inVC: self)
        }
    }
    
    private func getOffers(with conceptID: Int?,isLoading: Bool){
        if Network.isAvailable{
            if let conceptID = conceptID{
                self.isLoading = isLoading
                let request = OfferRequest(concept_id: conceptID)
                self.offersViewModel.getOffers(with: request)
            }
        }else{
            AlertController.showAlert(title: PisiffikStrings.alert(), message: PisiffikStrings.oopsNoInternetConnection(), inVC: self)
        }
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapOfferNewspaperSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let offerNewsPaperVC = R.storyboard.offerSB.offerNewspaperVC() else {return}
            self.push(controller: offerNewsPaperVC, hideBar: true, animated: true)
        }
    }
    
    @objc func didTapPersonalOfferSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigateToMyOfferAndBenefitWithSelected(mode: .forPersonal)
        }
    }
    
    @objc func didTapMembershipOfferSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigateToMyOfferAndBenefitWithSelected(mode: .forMembership)
        }
    }
    
    @objc func didTapLocalOfferSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigateToMyOfferAndBenefitWithSelected(mode: .forLocal)
        }
    }
    
    @objc func didTapOfferActivitiesSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let inboxVC = R.storyboard.profileSB.inboxVC() else {return}
            inboxVC.mode = .events
            self.push(controller: inboxVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapConceptSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapCartBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            guard let myCartVC = R.storyboard.homeSB.myCartVC() else {return}
            self.push(controller: myCartVC, hideBar: true, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR OFFERS VIEW MODEL DELEGATES -

extension OfferVC: OffersViewModelDelegate{
    
    func didReceiveOffers(response: OfferResponse) {
        self.isLoading = false
        if let responseData = response.data,
           let mediaURL = responseData.media_url,
           let concepts = responseData.concepts,
           let personal = responseData.personal,
           let local = responseData.local,
           let membership = responseData.membership{
            self.arrayOfConcepts.removeAll()
            self.arrayOfPersonal.removeAll()
            self.arrayOfLocal.removeAll()
            self.arrayOfMembership.removeAll()
            self.mediaURL = mediaURL
            self.arrayOfConcepts = concepts.sorted(by: {$0.id ?? 0 < $1.id ?? 0})
            self.arrayOfPersonal = personal
            self.arrayOfLocal = local
            self.arrayOfMembership = membership
        }
        DispatchQueue.main.async { [weak self] in
            self?.offerTableView.reloadData()
        }
    }
    
    func didReceiveOffersResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR OFFER EVENTS VIEW MODEL DELEGATES -

extension OfferVC: OfferEventsViewModelDelegate{
    
    func didReceiveOfferEvents(response: OfferEventsBaseResponse) {
        if let data = response.data?.offers{
            self.offerEventsData = data
            self.getOffers(with: self.selectedConceptID, isLoading: true)
        }
    }
    
    func didReceiveOfferEventsResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.offerTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.offerTableView.reloadData()
            self.offerTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.offerEventsViewModel.getOfferEvents()
            }
        }
    }
    
}

//MARK: - EXTENSION FOR DIGITAL NEWSPAPER DELEGATES -

extension OfferVC: OffersNewspaperViewModelDelegate{
    
    func didReceiveDigitalNewpapers(response: NewspaperResponse) {
        if let newspapers = response.data?.newspapers{
            self.digitalNewspapers = newspapers
            self.getOfferEventsRequest()
        }
    }
    
    func didReceiveDigitalNewpapersResponseWith(errorMessage: [String]?, statusCode: Int?) {
        
    }
    
}

//MARK: - EXTENSION FOR ADD PISIFFIK TO SHOPPING LIST VIEW MODEL DELEGATES -

extension OfferVC: AddPisiffikItemToCartViewModelDelegate{
    
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

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension OfferVC: AddToFavoriteViewModelDelegate{
    
    func didAddFoodItemToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.offerTableView.reloadData()
        }
    }
    
    func didFailToFoodItemToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension OfferVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveFoodItemFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.offerTableView.reloadData()
        }
    }
    
    func didFailToRemoveFoodItemFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension OfferVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading{
            return 6
        }else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return isLoading ? 1 : self.digitalNewspapers.count > 0 ? 1 : 0
            
        case 1:
            return isLoading ? 1 : self.arrayOfConcepts.count > 0 ? 1 : 0
            
        case 2:
            return isLoading ? 1 : self.arrayOfPersonal.count > 0 ? 1 : 0
            
        case 3:
            return isLoading ? 1 : self.arrayOfMembership.count > 0 ? 1 : 0
            
        case 4:
            return isLoading ? 1 : self.arrayOfLocal.count > 0 ? 1 : 0
            
        case 5:
            return isLoading ? 1 : self.offerEventsData.events?.count ?? 0 > 0 ? 1 : 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            return configureNewspaperCell(at: indexPath)
        case 1:
            return configureBannerCell(at: indexPath)
        case 2:
            return configurePersonalOfferCell(at: indexPath)
        case 3:
            return configureMembershipOfferCell(at: indexPath)
        case 4:
            return configureLocalOfferCell(at: indexPath)
        case 5:
            return configureOfferActivitiesCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}


//MARK: - EXTENSION FOR CONFIGURE CELLS -

extension OfferVC{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .offerConceptCell, for: indexPath) as! OfferConceptCell
        
        return cell
    }
    
    private func configureBannerCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .offerBannerCell, for: indexPath) as! OfferBannerCell
        
        cell.seeAllBtn.isHidden = true
        
        if (self.isLoading && self.arrayOfConcepts.isEmpty){
            cell.setSkeletonView()
            cell.isLoading = true
            
        }else{
            cell.hideSkeletonView()
            cell.selectedConceptID = self.selectedConceptID
            cell.mediaURL = self.mediaURL
            cell.arrayOfConcept = self.arrayOfConcepts
            cell.isLoading = false
        }

        return cell
    }
    
    private func configureNewspaperCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .offerNewspaperCell, for: indexPath) as! OfferNewspaperCell
        if isLoading{
            cell.isLoading = self.isLoading
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            cell.newspapers = self.digitalNewspapers
            cell.isLoading = self.isLoading
            cell.delegate = self
            cell.seeAllBtn.addTarget(self, action: #selector(didTapOfferNewspaperSeeAllBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    private func configurePersonalOfferCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .personalOfferCell, for: indexPath) as! PersonalOfferCell
        if self.isLoading{
            cell.isLoading = true
            cell.showSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            cell.arrayOfProducts = self.arrayOfPersonal
            cell.isLoading = false
            cell.delegate = self
            cell.seeAllBtn.addTarget(self, action: #selector(didTapPersonalOfferSeeAllBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    private func configureMembershipOfferCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .membershipOfferCell, for: indexPath) as! MembershipOfferCell
        if isLoading{
            cell.isLoading = true
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeltonView()
            cell.arrayOfProducts = self.arrayOfMembership
            cell.isLoading = false
            cell.delegate = self
            cell.seeAllBtn.addTarget(self, action: #selector(didTapMembershipOfferSeeAllBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    private func configureLocalOfferCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .localOfferCell, for: indexPath) as! LocalOfferCell
        if isLoading{
            cell.isLoading = true
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            cell.arrayOfProducts = self.arrayOfLocal
            cell.isLoading = false
            cell.delegate = self
            cell.seeAllBtn.addTarget(self, action: #selector(didTapLocalOfferSeeAllBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    private func configureOfferActivitiesCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = self.offerTableView.dequeueReusableCell(withIdentifier: .offerActivitiesCell, for: indexPath) as! OfferActivitiesCell
        if isLoading{
            cell.isLoading = true
            cell.setSkeletonView()
        }else{
            cell.isLoading = false
            cell.hideSkeletonView()
            cell.activitiesCollectionView.reloadData()
            cell.arrayOfEvents = self.offerEventsData.events ?? []
            cell.delegates = self
            cell.seeAllBtn.addTarget(self, action: #selector(didTapOfferActivitiesSeeAllBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
}

//MARK: - EXTENSION FOR OFFER CELLS DELEGATES -

extension OfferVC: PersonalOfferCellDelegates, MembershipOfferCellDelegates, LocalOfferCellDelegates, OfferActivitiesCellDelegates, OfferNewspaperCellDelegates{
    
    func didTapNewsPaper(at index: IndexPath) {
        guard let webStr = self.digitalNewspapers[index.row].webLink else {return}
        guard let newsPaperDetailVC = R.storyboard.offerSB.offerNewspaperDetailVC() else {return}
        newsPaperDetailVC.webStr = webStr
        self.present(newsPaperDetailVC, animated: true)
    }
    
    func didGetPersonalOfferProductDetail(at index: IndexPath) {
        guard let offerID = self.arrayOfPersonal[index.row].id else {return}
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = self.arrayOfPersonal[index.row]
        offerDetailVC.offerID = offerID
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    func didAddPersonalOfferToShoppingList(at index: IndexPath) {
        if Network.isAvailable{
            guard let offerID = self.arrayOfPersonal[index.row].id,
                  let offerItemID = self.arrayOfPersonal[index.row].offerItemId else {return}
            let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
            self.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: index.row)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didTapPersonalOfferFavorite(at index: IndexPath, isFavorite: Int) {
        if Network.isAvailable{
            let request = AddFoodItemToFavoriteRequest(productID: self.arrayOfPersonal[index.row].id,offerItemID: self.arrayOfPersonal[index.row].offerItemId)
            if isFavorite == 0{
                self.arrayOfPersonal[index.row].isFavorite = 1
                self.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: index.row)
            }else{
                self.arrayOfPersonal[index.row].isFavorite = 0
                self.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: index.row)
                self.postUnfavoriteNotification(id: self.arrayOfPersonal[index.row].id ?? 0, isFavorite: 0)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didGetMembershipOfferProductDetail(at index: IndexPath) {
        guard let offerID = self.arrayOfMembership[index.row].id else {return}
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = self.arrayOfMembership[index.row]
        offerDetailVC.offerID = offerID
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    func didAddMembershipOfferToShoppingList(at index: IndexPath) {
        if Network.isAvailable{
            guard let offerID = self.arrayOfMembership[index.row].id,
                  let offerItemID = self.arrayOfMembership[index.row].offerItemId else {return}
            let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
            self.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: index.row)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didTapMembershipOfferFavorite(at index: IndexPath, isFavorite: Int) {
        if Network.isAvailable{
            let request = AddFoodItemToFavoriteRequest(productID: self.arrayOfMembership[index.row].id,offerItemID: self.arrayOfMembership[index.row].offerItemId)
            if isFavorite == 0{
                self.arrayOfMembership[index.row].isFavorite = 1
                self.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: index.row)
            }else{
                self.arrayOfMembership[index.row].isFavorite = 0
                self.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: index.row)
                self.postUnfavoriteNotification(id: self.arrayOfMembership[index.row].id ?? 0, isFavorite: 0)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didGetLocalOfferProductDetail(at index: IndexPath) {
        guard let offerID = self.arrayOfLocal[index.row].id else {return}
        guard let offerDetailVC = R.storyboard.homeSB.offerDetailVC() else {return}
        offerDetailVC.offerData = self.arrayOfLocal[index.row]
        offerDetailVC.offerID = offerID
        offerDetailVC.mode = .fromHome
        offerDetailVC.delegates = self
        self.push(controller: offerDetailVC, hideBar: true, animated: true)
    }
    
    func didAddLocalOfferToShoppingList(at index: IndexPath) {
        if Network.isAvailable{
            guard let offerID = self.arrayOfLocal[index.row].id,
                  let offerItemID = self.arrayOfLocal[index.row].offerItemId else {return}
            let request = AddPisiffikProductRequest(variantID: offerID, offerItemID: offerItemID, uomQuantity: 1)
            self.addToShoppingViewModel.addPisiffikItemsToShopping(list: [request], indexPath: index.row)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didTapLocalOfferFavorite(at index: IndexPath, isFavorite: Int) {
        if Network.isAvailable{
            let request = AddFoodItemToFavoriteRequest(productID: self.arrayOfLocal[index.row].id,offerItemID: self.arrayOfLocal[index.row].offerItemId)
            if isFavorite == 0{
                self.arrayOfLocal[index.row].isFavorite = 1
                self.favoriteViewModel.addFoodItemToFavoriteList(request: request, indexPath: index.row)
            }else{
                self.arrayOfLocal[index.row].isFavorite = 0
                self.unFavoriteViewModel.removeFoodItemFromFavoriteList(request: request, indexPath: index.row)
                self.postUnfavoriteNotification(id: self.arrayOfLocal[index.row].id ?? 0, isFavorite: 0)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func didGetActivityDetail(at index: IndexPath) {
        if LocationManager.shared.userDeniedLocation{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDistanceAlertMessage(),cancelBtnHide: false, delegate: self)
        }else{
            let event = self.offerEventsData.events?[index.row]
            guard let eventID = self.offerEventsData.events?[index.row].id else {return}
            let currentEvent = EventsList(id: event?.id, name: event?.name, description: event?.description, image: event?.image, date: event?.date, isRead: event?.isRead)
            EventIDLocalManager.shared.saveEventID(id: eventID)
            guard let eventDetailVC = R.storyboard.profileSB.eventDetailVC() else {return}
            eventDetailVC.eventID = eventID
            eventDetailVC.event = currentEvent
            self.push(controller: eventDetailVC, hideBar: true, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR STORE HELP DELEGATE VC -

extension OfferVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}

//MARK: - EXTENSION FOR OFFER DETAIL DELEGATES -

extension OfferVC: PisiffikItemDetailProtocol{
    
    func didPisiffikItem(isFavorite: Int,by id: Int){
        if let index = self.arrayOfPersonal.firstIndex(where: {$0.id == id}){
            self.arrayOfPersonal[index].isFavorite = isFavorite
        }
        if let index = self.arrayOfLocal.firstIndex(where: {$0.id == id}){
            self.arrayOfLocal[index].isFavorite = isFavorite
        }
        if let index = self.arrayOfMembership.firstIndex(where: {$0.id == id}){
            self.arrayOfMembership[index].isFavorite = isFavorite
        }
        DispatchQueue.main.async { [weak self] in
            self?.offerTableView.reloadData()
        }
    }
    
}

//MARK: - EXTENSION FOR POST NOTIFICATION -

extension OfferVC{
    
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
