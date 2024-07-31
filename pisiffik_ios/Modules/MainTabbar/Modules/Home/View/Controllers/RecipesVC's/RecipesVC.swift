//
//  RecipesVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class RecipesVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var recipesTableView: UITableView!{
        didSet{
            recipesTableView.delegate = self
            recipesTableView.dataSource = self
            recipesTableView.register(R.nib.breakfastCell)
        }
    }
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - PROPERTIES -
    
    private var allRecipesViewModel = AllRecipeViewModel()
    private var addToFavoriteViewModel = AddToFavoriteViewModel()
    private var removeFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var searcViewModel = AllRecipeSearchViewModel()
    private var isLoading : Bool = false
    private var allRecipes : [AllRecipeCategories] = []
    private var searchingList : [AllRecipeCategories] = []
    private var isSearching : Bool = false
    private var currentIndexPath : IndexPath = IndexPath()
    private var recipeSectionIndex : IndexPath = IndexPath()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.allRecipesViewModel.delegate = self
        addToFavoriteViewModel.delegate = self
        removeFavoriteViewModel.delegate = self
        searcViewModel.delegate = self
        getAllRecipes()
        searchBarBackView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.recipes()
        searchTextField.placeholder = PisiffikStrings.search()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        searchTextField.addTarget(self, action: #selector(handleSearchBar(_:)), for: .editingChanged)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getAllRecipes(){
        if !Network.isAvailable{
            self.recipesTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.allRecipesViewModel.getAllRecipes()
            }
        }else{
            self.isLoading = true
            self.allRecipesViewModel.getAllRecipes()
        }
    }
    
    private func navigateToRecipesDetailVC(with title: String,recipeTypeID: Int,indexPath: IndexPath){
        guard let recipeSearchVC = R.storyboard.homeSB.recipesSearchVC() else {return}
        recipeSearchVC.currentTitle = title
        recipeSearchVC.currentRecipeTypeID = recipeTypeID
        recipeSearchVC.currentIndexPath = indexPath
        recipeSearchVC.delegate = self
        self.push(controller: recipeSearchVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapSeeAllBtn(_ sender: UIButton){
        sender.showAnimation {
//            guard let self = self else {return}
//            guard _ = self.allRecipes[sender.tag].recipeTypeID,
//                  _ = self.allRecipes[sender.tag].recipeType else {return}
//            self.navigateToRecipesDetailVC(with: titleString,recipeTypeID: recipeTypeID)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapProfileBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
}

//MARK: - EXTENSION FOR ALL RECIPES VIEW MODEL DELEGATES -

extension RecipesVC: AllRecipeViewModelDelegate{
    
    func didReceiveAllRecipes(response: AllRecipeRespone) {
        self.isLoading = false
        if let data = response.data?.recipeCategories{
            self.allRecipes = data
            DispatchQueue.main.async { [weak self] in
                self?.recipesTableView.reloadData()
                self?.searchBarBackView.isHidden = false
            }
        }
    }
    
    func didReceiveAllRecipesResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.recipesTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.recipesTableView.reloadData()
            self.recipesTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.allRecipesViewModel.getAllRecipes()
            }
        }
    }
    
}

//MARK: - EXTENSION FOR AllRecipeSearchViewModel Delegates -

extension RecipesVC: AllRecipeSearchViewModelDelegate{
    
    func didReceiveAllRecipesSearchList(response: AllRecipeRespone) {
        self.searchingList.removeAll()
        isLoading = false
        if let list = response.data?.recipeCategories{
            if !list.isEmpty{
                self.searchingList = list
                DispatchQueue.main.async { [weak self] in
                    self?.recipesTableView.reloadData()
                }
            }else{
                self.recipesTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.recipesTableView.reloadData()
            }
        }
    }
    
    func didReceiveAllRecipesSearchListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isSearching = false
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}



//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension RecipesVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 3 : isSearching ? searchingList.count : self.allRecipes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            return configureSearchRecipeCell(at: indexPath)
        }else{
            return configureRecipesCell(at: indexPath)
        }
    }
    
}

//MARK: - EXTENSION FOR RECIPIES CELL -

extension RecipesVC{
    
    private func configureRecipesCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: .breakfastCell, for: indexPath) as! BreakfastCell
        
        if isLoading{
            cell.isLoading = true
            cell.setSkeletonView()
        }else{
            cell.isLoading = false
            cell.hideSkeletonView()
            cell.arrayOfRecipes = self.allRecipes[indexPath.section].recipes ?? []
            cell.titleLbl.text = self.allRecipes[indexPath.section].recipeType
            cell.delegate = self
            cell.seeAllBtn.tag = indexPath.section
            cell.indexPath = indexPath
            cell.seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            
            cell.seeAllBtn.addTapGestureRecognizer { [weak self] in
                guard let recipeTypeID = self?.allRecipes[indexPath.section].recipeTypeID,
                      let titleString = self?.allRecipes[indexPath.section].recipeType else {return}
                self?.currentIndexPath = indexPath
                self?.navigateToRecipesDetailVC(with: titleString,recipeTypeID: recipeTypeID,indexPath: indexPath)
            }
            
        }
        
        return cell
    }
    
    
    private func configureSearchRecipeCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: .breakfastCell, for: indexPath) as! BreakfastCell
        
        if isLoading{
            cell.isLoading = true
            cell.setSkeletonView()
        }else{
            cell.isLoading = false
            cell.hideSkeletonView()
            cell.arrayOfRecipes = self.searchingList[indexPath.section].recipes ?? []
            cell.titleLbl.text = self.searchingList[indexPath.section].recipeType
            cell.delegate = self
            cell.seeAllBtn.tag = indexPath.section
            cell.indexPath = indexPath
            cell.seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            
            cell.seeAllBtn.addTapGestureRecognizer { [weak self] in
                guard let recipeTypeID = self?.searchingList[indexPath.section].recipeTypeID,
                      let titleString = self?.searchingList[indexPath.section].recipeType else {return}
                self?.currentIndexPath = indexPath
                self?.navigateToRecipesDetailVC(with: titleString,recipeTypeID: recipeTypeID,indexPath: indexPath)
            }
            
        }
        
        return cell
    }
    
}



//MARK: - EXTENSION FOR RECIPES CELL DELEGATES -

extension RecipesVC: RecipesCellDelagtes{
    
    func didTapOnRecipeCell(at indexPath: IndexPath,id: Int) {
        guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
        if isSearching{
            recipeDetailVC.currentTitle = self.searchingList[indexPath.section].recipeType ?? PisiffikStrings.recipes()
        }else{
            recipeDetailVC.currentTitle = self.allRecipes[indexPath.section].recipeType ?? PisiffikStrings.recipes()
        }
        recipeDetailVC.currentID = id
        recipeDetailVC.delegate = self
        self.push(controller: recipeDetailVC, hideBar: true, animated: true)
    }
    
    func didTapOnRecipeFavoriteBtn(at indexPath: IndexPath,id: Int) {
        self.recipeSectionIndex = indexPath
        if isSearching{
            
            guard let index = self.searchingList[indexPath.section].recipes?.firstIndex(where: {$0.id == id}) ,
                  let isFavorite = self.searchingList[indexPath.section].recipes?[index].isFavorite else {return}
            let request = AddRecipeToFavoriteRequest(recipeID: id)
            
            if Network.isAvailable{
                
                if isFavorite == 0{
                    self.addToFavoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: indexPath.row)
                    self.searchingList[indexPath.section].recipes?[index].isFavorite = 1
                    if !allRecipes.isEmpty{
                        for sectionIndex in (0...(self.allRecipes.count - 1)){
                            if let recipeIndex = self.allRecipes[sectionIndex].recipes?.firstIndex(where: {$0.id == id}){
                                self.allRecipes[sectionIndex].recipes?[recipeIndex].isFavorite = 1
                            }
                        }
                    }
                    postNotification(recipeID: id, isFavorite: 1)
                    
                }else{
                    self.removeFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: indexPath.row)
                    self.searchingList[indexPath.section].recipes?[index].isFavorite = 0
                    if !allRecipes.isEmpty{
                        for sectionIndex in (0...(self.allRecipes.count - 1)){
                            if let recipeIndex = self.allRecipes[sectionIndex].recipes?.firstIndex(where: {$0.id == id}){
                                self.allRecipes[sectionIndex].recipes?[recipeIndex].isFavorite = 0
                            }
                        }
                    }
                    postNotification(recipeID: id, isFavorite: 0)
                    
                }
                
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.recipesTableView.reloadData()
                }
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
            
        }else{
            
            guard let index = self.allRecipes[indexPath.section].recipes?.firstIndex(where: {$0.id == id}) ,
                  let isFavorite = self.allRecipes[indexPath.section].recipes?[index].isFavorite else {return}
            
            let request = AddRecipeToFavoriteRequest(recipeID: id)
            if Network.isAvailable{
                if isFavorite == 0{
                    self.addToFavoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: indexPath.row)
                    self.allRecipes[indexPath.section].recipes?[index].isFavorite = 1
                    postNotification(recipeID: id, isFavorite: 1)
                }else{
                    self.removeFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: indexPath.row)
                    self.allRecipes[indexPath.section].recipes?[index].isFavorite = 0
                    postNotification(recipeID: id, isFavorite: 0)
                }
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.recipesTableView.reloadData()
                }
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
            
        }
        
    }
    
}

//MARK: - EXTENSION FOR RecipeFavoritesDelegates -

extension RecipesVC: RecipeFavoritesDelegates{
    
    func didFavoriteRecipeBy(id: Int, isFavorite: Int, at index: Int,indexPath: IndexPath?) {
        self.postNotification(recipeID: id, isFavorite: isFavorite)
        if isSearching{
            
            if !searchingList.isEmpty{
                for sectionIndex in (0...(searchingList.count - 1)){
                    if let recipeIndex = self.searchingList[sectionIndex].recipes?.firstIndex(where: {$0.id == id}){
                        self.searchingList[sectionIndex].recipes?[recipeIndex].isFavorite = isFavorite
                    }
                }
            }
            if !allRecipes.isEmpty{
                for sectionIndex in (0...(allRecipes.count - 1)){
                    if let recipeIndex = self.allRecipes[sectionIndex].recipes?.firstIndex(where: {$0.id == id}){
                        self.allRecipes[sectionIndex].recipes?[recipeIndex].isFavorite = isFavorite
                    }
                }
            }
            
        }else{
            if !allRecipes.isEmpty{
                for sectionIndex in (0...(allRecipes.count - 1)){
                    if let recipeIndex = self.allRecipes[sectionIndex].recipes?.firstIndex(where: {$0.id == id}){
                        self.allRecipes[sectionIndex].recipes?[recipeIndex].isFavorite = isFavorite
                    }
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.recipesTableView.reloadData()
        }
    }
    
    
}


//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension RecipesVC: AddToFavoriteViewModelDelegate{
    
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.recipesTableView.reloadData()
        }
    }
    
    func didFailToAddRecipeToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.recipesTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension RecipesVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {

    }
    
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.recipesTableView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}


//MARK: - EXTENSION FOR SEARCH BAR -

extension RecipesVC{
    
    @objc func handleSearchBar(_ searchBarField: UITextField) {
            
            NSObject.cancelPreviousPerformRequests(
                    withTarget: self,
                    selector: #selector(self.getTextFromSearchField),
                    object: searchBarField)
                self.perform(
                    #selector(self.getTextFromSearchField),
                    with: searchBarField,
                    afterDelay: 0.5)
        }
        
        @objc func getTextFromSearchField(textField: UITextField) {
            if let text = textField.text{
                if text.isEmpty{
                    isSearching = false
                    searchTextField.text = ""
                    self.recipesTableView.reloadData()
                }else{
                    if Network.isAvailable{
                        let request = AllRecipeCategoriesSearchRequest(keyword: text, searchIn: .CATEGORIZED)
                        self.searcViewModel.getAllRecipesSearchList(request: request)
                        isSearching = true
                        isLoading = true
                        self.recipesTableView.reloadData()
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                    }
                }
            }else{
                isSearching = false
                searchTextField.text = ""
                self.recipesTableView.reloadData()
            }
        }
    
}


extension RecipesVC{
    
    private func postNotification(recipeID: Int,isFavorite: Int){
        let userInfo : [String: Any] = [.recipeID: recipeID, .isFavorite: isFavorite]
        NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
    }
    
}
