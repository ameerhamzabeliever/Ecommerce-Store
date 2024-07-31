//
//  PreferenceVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

struct PreferencesRequestModel{
    var id : Int?
    var isPrefered : Int?
}

class PreferenceVC: BaseVC {
    
    //MARK: - OUTLET -
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var conceptTitleLabel: UILabel! {
        didSet {
            conceptTitleLabel.font = Fonts.mediumFontsSize16
            conceptTitleLabel.textColor = R.color.textBlackColor()
            conceptTitleLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var conceptCollectionView: UICollectionView!{
        didSet{
            conceptCollectionView.register(R.nib.conceptsCell)
        }
    }
  
    @IBOutlet weak var categoryTitleLabel: UILabel! {
        didSet {
            categoryTitleLabel.font = Fonts.mediumFontsSize16
            categoryTitleLabel.textColor = R.color.textBlackColor()
            categoryTitleLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var categoryCollectionView: UICollectionView!{
        didSet{
            categoryCollectionView.register(R.nib.categoryCell)
        }
    }
    @IBOutlet weak var prefrencesBtn: LoadingButton!{
        didSet{
            prefrencesBtn.setImage(R.image.ic_disable_prefrences_icon(), for: .normal)
            prefrencesBtn.setImage(R.image.ic_enable_prefrences_icon(), for: .selected)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var preferencesViewModel = PreferencesListViewModel()
    private var removePreferenceViewModel = RemovePreferenceViewModel()
    private var arrayOfConcepts : [PreferencesListConcepts] = []
    private var arrayOfCatrgories : [PreferencesListCategories] = []
    private var isLoading : Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    private var arrayOfConceptID : [PreferencesRequestModel] = []
    private var arrayOfCategoryID : [PreferencesRequestModel] = []{
        didSet{
            self.setContinueBtn()
        }
    }
    
    private var lastListCount : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        preferencesViewModel.delegate = self
        removePreferenceViewModel.delegate = self
        getPreferencesList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContinueBtn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lastListCount = 0
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.preferences()
        conceptTitleLabel.text = PisiffikStrings.concept()
        categoryTitleLabel.text = PisiffikStrings.categories()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getPreferencesList(){
        if Network.isAvailable{
            self.isLoading = true
            self.preferencesViewModel.getPreferencesList()
        }else{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.oopsNoInternetConnection(), delegate: self)
        }
    }
    
    private func setContinueBtn(){
        if !self.arrayOfCategoryID.isEmpty{
            self.prefrencesBtn.isSelected = true
            prefrencesBtn.setImage(R.image.ic_enable_prefrences_icon(), for: .selected)
        }else{
            self.prefrencesBtn.isSelected = false
            prefrencesBtn.setImage(R.image.ic_disable_prefrences_icon(), for: .normal)
        }
    }
    
    private func configureSkeletonView(){
        if isLoading{
            self.setSkeletonView()
        }else{
            self.hideSkeletonView()
        }
    }
    
    private func setSkeletonView(){
        conceptTitleLabel.showAnimatedGradientSkeleton()
        categoryTitleLabel.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeletonView(){
        conceptTitleLabel.hideSkeleton()
        categoryTitleLabel.hideSkeleton()
    }
    
    private func navigateToPreferencesDetailVC(){
        var conceptIDs : Set<Int> = []
        if !arrayOfConceptID.isEmpty{
            for obj in self.arrayOfConceptID{
                if let id = obj.id{
                    conceptIDs.insert(id)
                }
            }
        }else{
            conceptIDs = []
        }
        guard let prefDetailVC = R.storyboard.preferencesSB.preferencesDetailVC() else {return}
        prefDetailVC.delegate = self
        prefDetailVC.arrayOfConceptID = conceptIDs
        self.push(controller: prefDetailVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        if Network.isAvailable{
            self.updatePreferences()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton) {
        sender.showAnimation {
            if Network.isAvailable{
                self.updatePreferences()
            }
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapPreferencesBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.prefrencesBtn.isSelected{
                self.updatePreferences()
            }
        }
    }
    
}

//MARK: - EXTENSION FOR PREFERENCES LIST VIEW MODEL DELEGATES -

extension PreferenceVC: PreferencesListViewModelDelegate, StoreHelpVCDelegates{
    
    func didReceivePreferencesList(response: PreferencesListResponse) {
        self.isLoading = false
        if let concepts = response.data?.concepts,
           let categories = response.data?.categories{
            if !concepts.isEmpty{
                self.arrayOfConceptID.removeAll()
//                self.arrayOfConcepts = concepts
                for concept in concepts {
                    if concept.isPrefered == 1{
                        let item = PreferencesRequestModel(id: concept.id, isPrefered: concept.isPrefered)
                        self.arrayOfConceptID.append(item)
                        self.arrayOfConcepts.insert(concept, at: 0)
                    }else{
                        self.arrayOfConcepts.append(concept)
                    }
                }
            }else{
                self.conceptCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.conceptCollectionView.reloadData()
            }
            
            if !categories.isEmpty{
                self.arrayOfCatrgories = categories
                for category in categories {
                    if category.isPrefered == 1{
                        let item = PreferencesRequestModel(id: category.id, isPrefered: category.isPrefered)
                        self.arrayOfCategoryID.append(item)
                    }
                }
                self.lastListCount = (self.arrayOfCategoryID.count + self.arrayOfConceptID.count)
            }else{
                self.categoryCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.categoryCollectionView.reloadData()
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.conceptCollectionView.reloadData()
            self?.categoryCollectionView.reloadData()
        }
        
        //Again Reloading Due To Icon Tint Color....
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.categoryCollectionView.reloadData()
        }
        
    }
    
    func didReceivePreferencesListResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUpdatePreferences(response: UpdatePreferencesResponse){
        Constants.printLogs(response.message ?? "")
        if self.prefrencesBtn.isAnimating{
            self.prefrencesBtn.hideLoading()
            self.lastListCount = (self.arrayOfCategoryID.count + self.arrayOfConceptID.count)
            navigateToPreferencesDetailVC()
        }
    }
    
    func didReceiveUpdatePreferencesResponseWith(errorMessage: [String]?,statusCode: Int?){
        self.isLoading = false
        if self.prefrencesBtn.isAnimating{
            self.prefrencesBtn.hideLoading()
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
            DispatchQueue.main.async { [weak self] in
                self?.conceptCollectionView.reloadData()
                self?.categoryCollectionView.reloadData()
            }
        }
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), description: error?.first ?? "", delegate: self)
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - EXTENSION FOR REMOVE CATEGORY VIEW MODEL -

extension PreferenceVC: RemovePreferenceViewModelDelegate{
    
    func didReceiveRemovePreference(response: BaseResponse) {
        Constants.printLogs(response.responseMessage ?? "")
    }
    
    func didReceiveRemovePreferenceResponseWith(errorMessage: [String]?, statusCode: Int?) {
        Constants.printLogs(errorMessage?.first ?? "")
    }
    
}


//MARK: - EXTENSION FOR COLLECTIONVIEW VIEW -

extension PreferenceVC: CollectionViewMethods {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case conceptCollectionView:
            return isLoading ? 7 : arrayOfConcepts.count
        case categoryCollectionView:
            return isLoading ? 7 : arrayOfCatrgories.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case conceptCollectionView:
            return configureConceptCollectionView(collectionView: conceptCollectionView, cellForItem: indexPath)
        case categoryCollectionView:
            return configureCategoryCollectionView(collectionView: categoryCollectionView, cellForItem: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case conceptCollectionView:
            if self.prefrencesBtn.isAnimating {return}
            self.didSelectConceptCell(at: indexPath)
            self.conceptCollectionView.reloadData()
        case categoryCollectionView:
            if self.prefrencesBtn.isAnimating {return}
            self.didSelectCategoryCell(at: indexPath)
            self.categoryCollectionView.reloadData()
        default:
            return
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView {
        case conceptCollectionView:
            
            let frameSize = conceptCollectionView.frame.size
            
            if UIDevice().userInterfaceIdiom == .pad{
                return CGSize(width: frameSize.width / 4, height: (frameSize.height / 5))
            }else{
                return CGSize(width: frameSize.width / 3, height: (frameSize.height / 4))
            }
            
        case categoryCollectionView:
            let frameSize = categoryCollectionView.frame.size
            
            return CGSize(width: frameSize.width / 3, height: 90.0)
        default:
            return CGSize.zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}


extension PreferenceVC {
    
    func configureConceptCollectionView(collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .conceptsCell, for: indexPath) as! ConceptsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfConcepts[indexPath.row].image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            if arrayOfConcepts[indexPath.row].isPrefered == 1{
                cell.selectionImageView.image = R.image.ic_preferences_check()
            }else{
                cell.selectionImageView.image = R.image.ic_preferences_uncheck()
            }
            
        }
        
        return cell
    }
    
    
    func configureCategoryCollectionView(collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .categoryCell, for: indexPath) as! CategoryCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            cell.itemNameLbl.text = arrayOfCatrgories[indexPath.row].name
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfCatrgories[indexPath.row].image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
                cell.itemImageView.image = cell.itemImageView.image?.withRenderingMode(.alwaysTemplate)
            }
            if arrayOfCatrgories[indexPath.row].isPrefered == 1{
                cell.selectionImageView.image = R.image.ic_preferences_check()
                cell.itemImageView.tintColor = R.color.darkBlueColor()
                cell.itemNameLbl.textColor = R.color.textBlueColor()
            }else{
                cell.selectionImageView.image = R.image.ic_preferences_uncheck()
                cell.itemImageView.tintColor = R.color.darkGrayColor()
                cell.itemNameLbl.textColor = R.color.textGrayColor()
            }
            
        }
        
        return cell
    }
    
    private func updatePreferences(){
        if Network.isAvailable{
            
            var categoryRequestArray : Set<Int> = []
            var conceptRequestArray : Set<Int> = []
            
            if !arrayOfConceptID.isEmpty{
                for concept in self.arrayOfConceptID{
                    conceptRequestArray.insert(concept.id ?? 0)
                }
            }
            
            if !arrayOfCategoryID.isEmpty{
                for category in self.arrayOfCategoryID{
                    categoryRequestArray.insert(category.id ?? 0)
                }
            }
            
            if !self.prefrencesBtn.isAnimating{
                self.prefrencesBtn.showLoading()
                let request = UpdatePreferenceRequest(category: categoryRequestArray, concept: conceptRequestArray)
                self.preferencesViewModel.updatePreferences(request: request)
            }
            
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    private func didSelectConceptCell(at indexPath: IndexPath){
        if Network.isAvailable{
            if arrayOfConcepts[indexPath.row].isPrefered == 0{
                arrayOfConcepts[indexPath.row].isPrefered = 1
            }else{
                arrayOfConcepts[indexPath.row].isPrefered = 0
            }
            if self.arrayOfConceptID.contains(where: {$0.id == arrayOfConcepts[indexPath.row].id}){
                if let index = self.arrayOfConceptID.firstIndex(where: {$0.id == arrayOfConcepts[indexPath.row].id}){
                    self.arrayOfConceptID.remove(at: index)
                }
            }else{
                let item = PreferencesRequestModel(id: self.arrayOfConcepts[indexPath.row].id, isPrefered: self.arrayOfConcepts[indexPath.row].isPrefered)
                self.arrayOfConceptID.append(item)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    private func didSelectCategoryCell(at indexPath: IndexPath){
        if Network.isAvailable{
            if arrayOfCatrgories[indexPath.row].isPrefered == 0{
                arrayOfCatrgories[indexPath.row].isPrefered = 1
            }else{
                arrayOfCatrgories[indexPath.row].isPrefered = 0
                var request = RemoveCategoryRequest()
                request.categoryID = arrayOfCatrgories[indexPath.row].id ?? 0
                self.removePreferenceViewModel.removePreferenceBy(request: request)
            }
            if self.arrayOfCategoryID.contains(where: {$0.id == arrayOfCatrgories[indexPath.row].id}){
                if let index = self.arrayOfCategoryID.firstIndex(where: {$0.id == arrayOfCatrgories[indexPath.row].id}){
                    self.arrayOfCategoryID.remove(at: index)
                }
            }else{
                let item = PreferencesRequestModel(id: self.arrayOfCatrgories[indexPath.row].id, isPrefered: self.arrayOfCatrgories[indexPath.row].isPrefered)
                self.arrayOfCategoryID.append(item)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    
    
}



//MARK: - EXTENSION FOR NOTIFICATION OBSERVER -

extension PreferenceVC: PreferencesDetailDelegate{
    
    func didPreferencesSettingUpdate() {
        if Network.isAvailable{
            self.arrayOfCatrgories.removeAll()
            self.arrayOfConcepts.removeAll()
            self.arrayOfCategoryID.removeAll()
            self.isLoading = true
            DispatchQueue.main.async { [weak self] in
                self?.categoryCollectionView.reloadData()
                self?.conceptCollectionView.reloadData()
            }
            self.preferencesViewModel.getPreferencesList()
        }
    }
    
}
