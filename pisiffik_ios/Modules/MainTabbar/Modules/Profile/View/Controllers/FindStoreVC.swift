//
//  FindStoreVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView
import ActiveLabel
import CoreLocation

class FindStoreVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var storesTableView: ContentSizedTableView!{
        didSet{
            storesTableView.delegate = self
            storesTableView.dataSource = self
            storesTableView.register(R.nib.offersAvailableStoreCell)
        }
    }
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
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
    @IBOutlet weak var tableBackView: UIView!
    
    //MARK: - PROPERTIES -
    
    private var findStoreViewModel = FindNearbyStoresViewModel()
    private var arrayOfConcepts : [FindNearbyStoreConcepts] = []
    private var arrayOfStores : [PisiffikItemDetailStores] = []
    private var searchingList : [PisiffikItemDetailStores] = []
    private var isLoading : Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    private var isSearching : Bool = false
    private var isConceptChanged : Bool = false
    private var conceptID: Int = 0
    var currentSelectedIndex : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        findStoreViewModel.delegate = self
        getNearbyStores()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.findStore()
        conceptLbl.text = PisiffikStrings.concept()
        searchTextField.placeholder = PisiffikStrings.search()
        searchTextField.addTarget(self, action: #selector(didSearchingList(_:)), for: .editingChanged)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        conceptLbl.font = Fonts.mediumFontsSize18
        conceptLbl.textColor = R.color.textBlackColor()
        conceptLbl.text = PisiffikStrings.concept()
        seeAllBtn.semanticContentAttribute = .forceRightToLeft
        seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
        seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
        seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getNearbyStores(){
        self.searchBarView.isHidden = true
        seeAllBtn.isHidden = true
        if Network.isAvailable{
            
            if !LocationManager.shared.userDeniedLocation  && !LocationManager.shared.lat.isEmpty && !LocationManager.shared.long.isEmpty{
                
                self.isLoading = true
                let request = FindNearbyStoreRequest(conceptID: self.conceptID, latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
                self.findStoreViewModel.getNearbyStoresBy(request: request)
                
            }else{
                
                self.searchTextField.isHidden = true
                self.storesTableView.setEmptyDataSet(title: PisiffikStrings.somethingWentWron(), description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), shouldDisplay: true)
                self.storesTableView.reloadData()
                
            }
            
        }else{
            self.searchTextField.isHidden = true
            self.storesTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), shouldDisplay: true)
            self.storesTableView.reloadData()
        }
    }
    
    private func getNearbyStoresBy(conceptID: Int,indexPath: IndexPath){
        if Network.isAvailable{
            if !LocationManager.shared.userDeniedLocation  && !LocationManager.shared.lat.isEmpty && !LocationManager.shared.long.isEmpty{
                
                let request = FindNearbyStoreRequest(conceptID: conceptID, latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
                self.findStoreViewModel.getNearbyStoresBy(request: request)
                self.currentSelectedIndex = indexPath.row
                self.conceptCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.conceptCollectionView.reloadData()
                self.tableBackView.isHidden = false
                isConceptChanged = true
                isSearching = false
                
                self.searchTextField.text = ""
                self.searchTextField.resignFirstResponder()
                self.searchingList.removeAll()
                self.arrayOfStores.removeAll()
                DispatchQueue.main.async { [weak self] in
                    self?.storesTableView.reloadData()
                }
                
            }else{
                self.storesTableView.setEmptyDataSet(title: PisiffikStrings.somethingWentWron(), description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), shouldDisplay: true)
                self.storesTableView.reloadData()
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapDirectionBtn(_ sender: UIButton){
        sender.showAnimation {
            self.getStoreDirection(at: sender.tag)
        }
    }
    
    @objc func didSearchingList(_ textField: UITextField){
        if !isLoading && !isConceptChanged{
            searchStoresBy(textField)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton) {
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapConceptSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
}

//MARK: - EXTENSION FOR FindNearbyStoresViewModel DELEGATES -

extension FindStoreVC: FindNearbyStoresViewModelDelegate{
    
    func didReceiveNearbyStores(response: FindNearbyStoreResponse) {
        self.isLoading = false
        self.isConceptChanged = false
        if let stores = response.data?.stores,
           let concepts = response.data?.concepts {
            if !stores.isEmpty{
                self.arrayOfStores = stores
                DispatchQueue.main.async { [weak self] in
                    self?.storesTableView.reloadData()
                    self?.searchBarView.isHidden = false
                    self?.tableBackView.isHidden = false
                }
            }else{
                self.storesTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.storesTableView.reloadData()
                self.tableBackView.isHidden = true
            }
            
            if !concepts.isEmpty{
                self.arrayOfConcepts = concepts
                let allObj = FindNearbyStoreConcepts(id: 0, name: PisiffikStrings.all(), image: nil, isPrefered: 0)
                self.arrayOfConcepts.insert(allObj, at: 0)
                DispatchQueue.main.async { [weak self] in
                    self?.conceptCollectionView.reloadData()
                }
            }
            
        }
        
    }
    
    func didReceiveNearbyStoresResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.isConceptChanged = false
        self.storesTableView.setEmptyDataSet(title: errorMessage?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            
            let request = FindNearbyStoreRequest(conceptID: self.conceptID, latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
            self.findStoreViewModel.getNearbyStoresBy(request: request)
        }
        self.storesTableView.reloadData()
        self.conceptCollectionView.reloadData()
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.isConceptChanged = false
        self.storesTableView.reloadData()
        self.conceptCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.isConceptChanged = false
        self.storesTableView.reloadData()
        self.conceptCollectionView.reloadData()
        self.storesTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            
            let request = FindNearbyStoreRequest(conceptID: self.conceptID, latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
            self.findStoreViewModel.getNearbyStoresBy(request: request)
            
        }
    }
    
}


//MARK: -  EXTENSION FOR COLLECTION VIEW METODS -

extension FindStoreVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : arrayOfConcepts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureConceptCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        if indexPath.row == self.currentSelectedIndex {return}
        guard let conceptID = self.arrayOfConcepts[indexPath.row].id else {return}
        self.getNearbyStoresBy(conceptID: conceptID,indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.conceptCollectionView.frame.size
        return CGSize(width: 100.0, height: size.height)
    }
    
}

//MARK: - EXTENSION FOR CONCEPT CELL -

extension FindStoreVC{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.conceptCollectionView.dequeueReusableCell(withReuseIdentifier: .offerTabsTopCell, for: indexPath) as! OfferTabsTopCell
        
        if isLoading{
            cell.setSkeletonView()
            cell.backView.layer.borderWidth = 0
            
        }else{
            cell.hideSkeletonView()
            
            if indexPath.row == 0{
                cell.nameLbl.isHidden = false
                cell.offerImageView.isHidden = true
            }else{
                cell.nameLbl.isHidden = true
                cell.offerImageView.isHidden = false
            }
            
            cell.nameLbl.text = self.arrayOfConcepts[indexPath.row].name
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfConcepts[indexPath.row].image ?? "")"){
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
    
}



//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension FindStoreVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading || isConceptChanged ? 15 : isSearching ? searchingList.count : arrayOfStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            return configureFindStoreSearchingCell(at: indexPath)
        }else{
            return configureFindStoreCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading || isConceptChanged {return}
    }
    
}

//MARK: - EXTENSION FOR STORE CELL -

extension FindStoreVC{
    
    
    private func configureFindStoreCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = storesTableView.dequeueReusableCell(withIdentifier: .offersAvailableStoreCell, for: indexPath) as! OffersAvailableStoreCell
        
        if isLoading || isConceptChanged{
            cell.setSkeletonView()
            cell.isLoading = true
            
        }else{
            cell.isLoading = false
            cell.hideSkeletonView()
            cell.arrayOfTimings = self.arrayOfStores[indexPath.row].timings ?? []
            
            DispatchQueue.main.async {
                cell.hoursTableView.reloadData()
            }
            
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfStores[indexPath.row].conceptImage ?? "")"){
                cell.storeImageView.kf.indicatorType = .activity
                cell.storeImageView.kf.setImage(with: imageURL)
            }
            cell.distanceLbl.text = "\(self.arrayOfStores[indexPath.row].distance ?? "")"
            
            let customType = ActiveType.custom(pattern: "\(self.arrayOfStores[indexPath.row].name ?? ""),")
            cell.addressLbl.enabledTypes = [customType]
            cell.addressLbl.customColor[customType] = R.color.textLightBlackColor()
            cell.addressLbl.text = "\(self.arrayOfStores[indexPath.row].name ?? ""), \(self.arrayOfStores[indexPath.row].address ?? "")"
            
            cell.openingHoursLbl.text = PisiffikStrings.openingHours()
            
            cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
            cell.directionBtn.tag = indexPath.row
            cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    private func configureFindStoreSearchingCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = storesTableView.dequeueReusableCell(withIdentifier: .offersAvailableStoreCell, for: indexPath) as! OffersAvailableStoreCell
        
        if isLoading || isConceptChanged{
            cell.setSkeletonView()
            cell.isLoading = true
            
        }else{
            cell.isLoading = false
            cell.hideSkeletonView()
            cell.arrayOfTimings = self.searchingList[indexPath.row].timings ?? []
            
            DispatchQueue.main.async {
                cell.hoursTableView.reloadData()
            }
            
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.searchingList[indexPath.row].conceptImage ?? "")"){
                cell.storeImageView.kf.indicatorType = .activity
                cell.storeImageView.kf.setImage(with: imageURL)
            }
            cell.distanceLbl.text = "\(self.searchingList[indexPath.row].distance ?? "")"
            
            let customType = ActiveType.custom(pattern: "\(self.searchingList[indexPath.row].name ?? ""),")
            cell.addressLbl.enabledTypes = [customType]
            cell.addressLbl.customColor[customType] = R.color.textLightBlackColor()
            cell.addressLbl.text = "\(self.searchingList[indexPath.row].name ?? ""), \(self.searchingList[indexPath.row].address ?? "")"
            
            cell.openingHoursLbl.text = PisiffikStrings.openingHours()
            
            cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
            cell.directionBtn.tag = indexPath.row
            cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }

    
}

//MARK: - EXTENSION FOR STORE SEARCHING -

extension FindStoreVC{
    
    private func searchStoresBy(_ textField: UITextField){
        if let text = textField.text{
            if text.isEmpty{
                isSearching = false
                textField.text = ""
                self.storesTableView.reloadData()
            }else{
                searchingList = arrayOfStores.filter({$0.name?.localizedCaseInsensitiveContains(text) ?? false})
                isSearching = true
                if searchingList.isEmpty{
                    self.storesTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                }
                self.storesTableView.reloadData()
            }
        }else{
            isSearching = false
            textField.text = ""
            self.storesTableView.reloadData()
        }
    }
    
}


//MARK: - EXETENSION FOR STORE DIRECTION -

extension FindStoreVC: StoreHelpVCDelegates{
    
    private func getStoreDirection(at index: Int){
        
        if Network.isAvailable{
            if !LocationManager.shared.userDeniedLocation && !LocationManager.shared.lat.isEmpty && !LocationManager.shared.long.isEmpty{
                
                if isSearching{
                    
                    if let latitude = self.searchingList[index].latitude,
                       let longitude = self.searchingList[index].longitude,
                       let destinationLat = Double(latitude),
                       let destinationLng = Double(longitude),
                       let currentLat = Double(LocationManager.shared.lat),
                       let currentLng = Double(LocationManager.shared.long){
                        
                        guard let directionVC = R.storyboard.profileSB.directionVC() else {return}
                        directionVC.currentLat = currentLat
                        directionVC.currentLng = currentLng
                        directionVC.destinationLat = destinationLat
                        directionVC.destinationLng = destinationLng
                        directionVC.destinationName = self.searchingList[index].name ?? ""
                        self.push(controller: directionVC, hideBar: true, animated: true)
                        
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsStoreDirectionNotAvailable()])
                    }
                    
                }else{
                
                    if let latitude = self.arrayOfStores[index].latitude,
                       let longitude = self.arrayOfStores[index].longitude,
                       let destinationLat = Double(latitude),
                       let destinationLng = Double(longitude),
                       let currentLat = Double(LocationManager.shared.lat),
                       let currentLng = Double(LocationManager.shared.long){
                        
                        guard let directionVC = R.storyboard.profileSB.directionVC() else {return}
                        directionVC.currentLat = currentLat
                        directionVC.currentLng = currentLng
                        directionVC.destinationLat = destinationLat
                        directionVC.destinationLng = destinationLng
                        directionVC.destinationName = self.arrayOfStores[index].name ?? ""
                        self.push(controller: directionVC, hideBar: true, animated: true)
                        
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsStoreDirectionNotAvailable()])
                    }
                    
                }
                
            }else{
                self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), delegate: self)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
        
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
    
}

extension FindStoreVC{
    
    private func configureSkeletonView(){
        if isLoading{
            setSkeletonView()
        }else{
            hideSkeletonView()
        }
    }
    
    private func setSkeletonView(){
        self.conceptLbl.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeletonView(){
        self.conceptLbl.hideSkeleton()
    }
    
}




/*
 
 
 fileprivate func configureStoresCell(at indexPath: IndexPath) -> UITableViewCell{
     
     let cell = storesTableView.dequeueReusableCell(withIdentifier: .findStoreCell, for: indexPath) as! FindStoreCell
     
     cell.distanceLbl.text = "2.5\(PisiffikStrings.km())"
     cell.daysLbl.text = "\(PisiffikStrings.days()): Mon - Sun"
     cell.openingLbl.text = "\(PisiffikStrings.opening()): 09:00 - 22:00"
     cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
     
     cell.directionBtn.tag = indexPath.row
     cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
     
     return cell
     
 }
 
 */
