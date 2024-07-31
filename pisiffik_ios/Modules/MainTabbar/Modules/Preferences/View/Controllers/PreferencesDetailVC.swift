//
//  PreferencesDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

protocol PreferencesDetailDelegate{
    func didPreferencesSettingUpdate()
}

class PreferencesDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!{
        didSet{
            categoryCollectionView.delegate = self
            categoryCollectionView.dataSource = self
            categoryCollectionView.register(R.nib.categoriesCell)
        }
    }
    @IBOutlet weak var saveBtn: LoadingButton!
    @IBOutlet weak var categoryTableView: UITableView!{
        didSet{
            categoryTableView.delegate = self
            categoryTableView.dataSource = self
            categoryTableView.register(R.nib.preferencesDataCell)
        }
    }
    @IBOutlet weak var bannerImageView: UIImageView!{
        didSet{
            bannerImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - PROPERTIES -
    
    var viewModel = PreferencesDetailViewModel()
    var removePreferenceViewModel = RemovePreferenceViewModel()
    var isLoading : Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    var isSearching : Bool = false
    var arrayOfMainCategories : [PreferencesDetailCategoryData] = []
    var arrayOfSubCategories : [PreferencesSubCategoryDataModel] = []
    var searchingList : [PreferencesSubCategoryDataModel] = []
    var arrayOfCategoryID : Set<Int> = []{
        didSet{
            self.setSaveBtnState()
        }
    }
    var arrayOfConceptID : Set<Int> = []
    var currentCategoryIndex: Int = 0{
        didSet{
            self.setupMainCategoryImageView()
        }
    }
    var searchingIndexPath: Int = 0
    var currentMainCategoryID : Int = 0
    var delegate : PreferencesDetailDelegate?
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        removePreferenceViewModel.delegate = self
        getPreferencesDetailListBy(id: 0)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = ""
        searchBarTextField.placeholder = PisiffikStrings.search()
        bannerImageView.image = R.image.ic_electronic_banner()
        saveBtn.setTitle(PisiffikStrings.save(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        setSaveBtnState()
        searchBarTextField.addTarget(self, action: #selector(searchCategory(_:)), for: .editingChanged)
        if UIDevice().userInterfaceIdiom == .pad{
            headerView.frame = CGRect(x: 0, y: 0, width: self.categoryTableView.frame.width, height: 300)
        }else{
            headerView.frame = CGRect(x: 0, y: 0, width: self.categoryTableView.frame.width, height: 120)
        }
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getPreferencesDetailListBy(id: Int){
        if Network.isAvailable{
            isLoading = true
            self.currentMainCategoryID = id
            let request = GetPreferencesByIDRequest(mainCategoryId: self.currentMainCategoryID)
            viewModel.getPreferencesDetailListBy(request: request)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    private func setSaveBtnState(){
        if !self.arrayOfCategoryID.isEmpty{
            self.saveBtn.backgroundColor = R.color.darkBlueColor()
        }else{
            self.saveBtn.backgroundColor = R.color.textLightGrayColor()
        }
        Constants.printLogs("CategoryID's: \(self.arrayOfCategoryID)")
    }
    
    private func configureSkeletonView(){
        if isLoading{
            self.setSkeletonView()
        }else{
            self.hideSkeletonView()
        }
    }
    
    private func setSkeletonView(){
        bannerImageView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeletonView(){
        bannerImageView.hideSkeleton()
    }
    
    
    //MARK: - ACTIONS -
    
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.isLoading && !self.saveBtn.isAnimating && !self.arrayOfCategoryID.isEmpty{
                if Network.isAvailable{
                    self.saveBtn.showLoading()
                    let request = UpdatePreferenceRequest(category: self.arrayOfCategoryID, concept: self.arrayOfConceptID)
                    self.viewModel.updatePreferences(request: request)
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
        }
    }
    
}


//MARK: - EXTENSION FOR PREFERENCE VIEWMODEL DELEGATES -

extension PreferencesDetailVC: PreferencesDetailViewModelDelegate{
    
    func didReceivePreferencesDetail(response: PreferencesDetailResponse) {
        if let mainCategory = response.data?.mainCategory,
           let subCategory = response.data?.subCategory {
            self.isLoading = false
            if self.arrayOfMainCategories.isEmpty{
                self.arrayOfMainCategories = mainCategory
            }
            
            if let subCategoryChild = subCategory.child{
                if !subCategoryChild.isEmpty{
                    for index in (0...(subCategoryChild.count - 1)){
                        let item = PreferencesSubCategoryDataModel(subCategory: subCategoryChild[index], isOpen: false)
                        self.arrayOfSubCategories.append(item)
                    }
                }
            }
            
            if let alreadyPrefered = response.data?.alreadyPrefered{
                if !alreadyPrefered.isEmpty{
                    for id in alreadyPrefered{
                        self.arrayOfCategoryID.insert(id)
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                if self?.currentMainCategoryID == 0{
                    self?.categoryCollectionView.reloadData()
                    self?.titleLbl.text = response.data?.mainCategory?.first?.name
                    self?.setupMainCategoryImageView()
                }
                self?.categoryTableView.reloadData()
            }
        }
    }
    
    func didReceivePreferencesDetailResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUpdatePreferences(response: UpdatePreferencesResponse){
        saveBtn.hideLoading()
        self.delegate?.didPreferencesSettingUpdate()
        if Network.isAvailable{
            self.searchBarTextField.text = ""
            self.arrayOfMainCategories.removeAll()
            self.arrayOfSubCategories.removeAll()
            self.isLoading = true
            self.isSearching = false
            DispatchQueue.main.async { [weak self] in
                self?.bannerImageView.image = nil
                self?.currentMainCategoryID = 0
                self?.currentCategoryIndex = 0
                self?.searchBarTextField.resignFirstResponder()
                self?.categoryCollectionView.reloadData()
                self?.categoryTableView.reloadData()
                self?.viewModel.getPreferencesDetailListBy(request: GetPreferencesByIDRequest(mainCategoryId: 0))
            }
        }
        Constants.printLogs(response.message ?? "")
    }
    
    func didReceiveUpdatePreferencesResponseWith(errorMessage: [String]?,statusCode: Int?){
        self.isLoading = false
        saveBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
        DispatchQueue.main.async { [weak self] in
            self?.categoryTableView.reloadData()
            self?.categoryCollectionView.reloadData()
        }
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE CATEGORY VIEW MODEL -

extension PreferencesDetailVC: RemovePreferenceViewModelDelegate{
    
    func didReceiveRemovePreference(response: BaseResponse) {
        Constants.printLogs(response.responseMessage ?? "")
    }
    
    func didReceiveRemovePreferenceResponseWith(errorMessage: [String]?, statusCode: Int?) {
        Constants.printLogs(errorMessage?.first ?? "")
    }
    
}

//MARK: - EXTENISION FOR NEW CATEGORY API CALL -

extension PreferencesDetailVC{
    
    func didGetCategoryData(at indexPath: IndexPath){
        
        if Network.isAvailable{
            if self.currentCategoryIndex != indexPath.row{
                if let categoryID = self.arrayOfMainCategories[indexPath.row].id{
                    self.titleLbl.text = arrayOfMainCategories[indexPath.row].name
                    self.currentCategoryIndex = indexPath.row
                    self.arrayOfSubCategories.removeAll()
                    self.searchBarTextField.text = ""
                    self.isSearching = false
                    self.getPreferencesDetailListBy(id: categoryID)
                    DispatchQueue.main.async { [weak self] in
                        self?.categoryTableView.reloadData()
                        self?.searchBarTextField.resignFirstResponder()
                    }
                }
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    func updateArrayOfCategoryID(at indexPath: IndexPath){
        if indexPath.row == 0{
            if self.arrayOfCategoryID.contains(where: {$0 == self.arrayOfSubCategories[indexPath.section].subCategory.id}){
                if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == self.arrayOfSubCategories[indexPath.section].subCategory.id}){
                    self.arrayOfCategoryID.remove(at: index)
                }
                if let subCategory = self.arrayOfSubCategories[indexPath.section].subCategory.child{
                    if !subCategory.isEmpty && !arrayOfCategoryID.isEmpty{
                        for category in subCategory{
                            if self.arrayOfCategoryID.contains(where: {$0 == category.id}){
                                if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == category.id}){
                                    self.arrayOfCategoryID.remove(at: index)
                                }
                            }
                        }
                    }
                }
            }else{
                self.arrayOfCategoryID.insert(self.arrayOfSubCategories[indexPath.section].subCategory.id ?? 0)
                if let subCategory = self.arrayOfSubCategories[indexPath.section].subCategory.child{
                    if !subCategory.isEmpty{
                        for category in subCategory{
                            if !self.arrayOfCategoryID.contains(where: {$0 == category.id ?? 0}){
                                self.arrayOfCategoryID.insert(category.id ?? 0)
                            }
                        }
                    }
                }
            }
        }else{
            
            if let subCategoryID = self.arrayOfSubCategories[indexPath.section].subCategory.child?[indexPath.row - 1].id{
                if self.arrayOfCategoryID.contains(where: {$0 == subCategoryID}){
                    if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == subCategoryID}){
                        self.arrayOfCategoryID.remove(at: index)
                    }
                }else{
                    self.arrayOfCategoryID.insert(subCategoryID)
                }
            }
            
        }
    }
    
    func updateSearchingArrayOfCategoryID(at indexPath: IndexPath){
        if indexPath.row == 0{
            if self.arrayOfCategoryID.contains(where: {$0 == self.searchingList[indexPath.section].subCategory.id}){
                if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == self.searchingList[indexPath.section].subCategory.id}){
                    self.arrayOfCategoryID.remove(at: index)
                }
                if let subCategory = self.searchingList[indexPath.section].subCategory.child{
                    if !subCategory.isEmpty && !arrayOfCategoryID.isEmpty{
                        for category in subCategory{
                            if self.arrayOfCategoryID.contains(where: {$0 == category.id}){
                                if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == category.id}){
                                    self.arrayOfCategoryID.remove(at: index)
                                }
                            }
                        }
                    }
                }
            }else{
                self.arrayOfCategoryID.insert(self.searchingList[indexPath.section].subCategory.id ?? 0)
                if let subCategory = self.searchingList[indexPath.section].subCategory.child{
                    if !subCategory.isEmpty{
                        for category in subCategory{
                            if !self.arrayOfCategoryID.contains(where: {$0 == category.id ?? 0}){
                                self.arrayOfCategoryID.insert(category.id ?? 0)
                            }
                        }
                    }
                }
            }
        }else{
            
            if let subCategoryID = self.searchingList[indexPath.section].subCategory.child?[indexPath.row - 1].id{
                if self.arrayOfCategoryID.contains(where: {$0 == subCategoryID}){
                    if let index = self.arrayOfCategoryID.firstIndex(where: {$0 == subCategoryID}){
                        self.arrayOfCategoryID.remove(at: index)
                    }
                }else{
                    self.arrayOfCategoryID.insert(subCategoryID)
                }
            }
            
        }
    }
    
    func updateSubCategoryIsPrefered(section: Int,row: Int){
        if row == 0{
            if self.arrayOfSubCategories[section].subCategory.isPrefered == 1{
                self.arrayOfSubCategories[section].subCategory.isPrefered = 0
                if let child = self.arrayOfSubCategories[section].subCategory.child{
                    if child.isEmpty == false{
                        for index in (0...(child.count - 1)){
                            self.arrayOfSubCategories[section].subCategory.child?[index].isPrefered = 0
                        }
                    }
                }
            }else{
                self.arrayOfSubCategories[section].subCategory.isPrefered = 1
                if let child = self.arrayOfSubCategories[section].subCategory.child{
                    if child.isEmpty == false{
                        for index in (0...(child.count - 1)){
                            self.arrayOfSubCategories[section].subCategory.child?[index].isPrefered = 1
                        }
                    }
                }
            }
            
        }else{
            
            if self.arrayOfSubCategories[section].subCategory.child?[row - 1].isPrefered == 1{
                self.arrayOfSubCategories[section].subCategory.child?[row - 1].isPrefered = 0
            }else{
                self.arrayOfSubCategories[section].subCategory.child?[row - 1].isPrefered = 1
            }
            
        }
        DispatchQueue.main.async { [weak self] in
            self?.categoryTableView.reloadData()
        }
    }
    
    func removeSubCategoryID(row: Int, section: Int){
        if row == 0{
            if self.arrayOfCategoryID.contains(where: {$0 == self.arrayOfSubCategories[section].subCategory.id}){
                self.removePreferenceViewModel.removePreferenceBy(request: getCategoryRequest(id: self.arrayOfSubCategories[section].subCategory.id ?? 0))
            }
        }else{
            if self.arrayOfCategoryID.contains(where: {$0 == self.arrayOfSubCategories[section].subCategory.child?[row - 1].id ?? 0}){
                self.removePreferenceViewModel.removePreferenceBy(request: getCategoryRequest(id: self.arrayOfSubCategories[section].subCategory.child?[row - 1].id ?? 0))
            }
        }
    }
    
    func updateSearchSubCategoryIsPrefered(section: Int,row: Int){
        if row == 0{
            if self.searchingList[section].subCategory.isPrefered == 1{
                self.searchingList[section].subCategory.isPrefered = 0
                if let child = self.searchingList[section].subCategory.child{
                    if child.isEmpty == false{
                        for index in (0...(child.count - 1)){
                            self.searchingList[section].subCategory.child?[index].isPrefered = 0
                        }
                    }
                }
            }else{
                self.searchingList[section].subCategory.isPrefered = 1
                if let child = self.searchingList[section].subCategory.child{
                    if child.isEmpty == false{
                        for index in (0...(child.count - 1)){
                            self.searchingList[section].subCategory.child?[index].isPrefered = 1
                        }
                    }
                }
            }
            
        }else{
            
            if self.searchingList[section].subCategory.child?[row - 1].isPrefered == 1{
                self.searchingList[section].subCategory.child?[row - 1].isPrefered = 0
            }else{
                self.searchingList[section].subCategory.child?[row - 1].isPrefered = 1
            }
            
        }
        DispatchQueue.main.async { [weak self] in
            self?.categoryTableView.reloadData()
        }
    }
    
    func removeSearchingSubCategoryID(row: Int, section: Int){
        if row == 0{
            if self.arrayOfCategoryID.contains(where: {$0 == self.searchingList[section].subCategory.id}){
                self.removePreferenceViewModel.removePreferenceBy(request: getCategoryRequest(id: self.searchingList[section].subCategory.id ?? 0))
            }
        }else{
            if self.arrayOfCategoryID.contains(where: {$0 == self.searchingList[section].subCategory.child?[row - 1].id ?? 0}){
                self.removePreferenceViewModel.removePreferenceBy(request: getCategoryRequest(id: self.searchingList[section].subCategory.child?[row - 1].id ?? 0))
            }
        }
    }
    
    
}


//MARK: - EXTENSION FOR SEARCH BAR -

extension PreferencesDetailVC{
    
        @objc func searchCategory(_ textField: UITextField) {
            if let text = textField.text{
                if !isLoading{
                    if text.isEmpty{
                        isSearching = false
                        searchBarTextField.text = ""
                        DispatchQueue.main.async { [weak self] in
                            self?.categoryTableView.reloadData()
                        }
                    }else{
                        //API Call For Searching.....
                        isSearching = true
                        searchingList = arrayOfSubCategories.filter({$0.subCategory.name?.localizedCaseInsensitiveContains(text) ?? false})
                        DispatchQueue.main.async { [weak self] in
                            self?.categoryTableView.reloadData()
                        }
                    }
                }
            }else{
                isSearching = false
                searchBarTextField.text = ""
                DispatchQueue.main.async { [weak self] in
                    self?.categoryTableView.reloadData()
                }
            }
        }
    
    private func setupMainCategoryImageView(){
        if !isSearching && !isLoading{
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfMainCategories[self.currentCategoryIndex].banner ?? "")"){
                self.bannerImageView.image = nil
                self.bannerImageView.kf.indicatorType = .activity
                self.bannerImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    //    @objc func handleSearchBar(_ searchBarField: UITextField) {
    //
    //            NSObject.cancelPreviousPerformRequests(
    //                    withTarget: self,
    //                    selector: #selector(self.getTextFromSearchField),
    //                    object: searchBarField)
    //                self.perform(
    //                    #selector(self.getTextFromSearchField),
    //                    with: searchBarField,
    //                    afterDelay: 0.5)
    //        }
    
}
