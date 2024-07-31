//
//  RecipesSearchVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class RecipesSearchVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var recipesCollectionView: UICollectionView!{
        didSet{
            recipesCollectionView.delegate = self
            recipesCollectionView.dataSource = self
            recipesCollectionView.register(R.nib.recipesSubCell)
        }
    }
    @IBOutlet weak var searchBarBackView: UIView!
    
    //MARK: - PROPERTIES -
    
    private var recipeViewModel : RecipeListViewModel = RecipeListViewModel()
    private var recipeSearchViewModel : RecipeSearchListViewModel = RecipeSearchListViewModel()
    private var favoriteViewModel = AddToFavoriteViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    var currentTitle: String?
    private var isLoading : Bool = false
    private var arrayOfRecipes : [RecipeDetailAboutData] = []
    private var searchingList : [RecipeDetailAboutData] = []
    private var currentPage : Int = 0
    private var newsCurrentPage : Int = 0
    private var newsLastPage : Int = 0
    var currentRecipeTypeID: Int = 0
    private var isSearching : Bool = false
    var currentIndexPath : IndexPath = IndexPath()
    var delegate : RecipeFavoritesDelegates?
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        recipeViewModel.delegate = self
        recipeSearchViewModel.delegate = self
        favoriteViewModel.delegate = self
        unFavoriteViewModel.delegate = self
        getRecipeList()
        self.searchBarBackView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        if let currentTitle = currentTitle {
            titleLbl.text = currentTitle
        }
        searchBar.placeholder = PisiffikStrings.search()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        searchBar.addTarget(self, action: #selector(handleSearchBar(_:)), for: .editingChanged)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getRecipeList(){
        if !Network.isAvailable{
            self.recipesCollectionView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.currentPage += 1
                if self.currentPage == 1{
                    self.isLoading = true
                }else{
                    self.isLoading = false
                }
                let request = RecipeListRequest(recipeTypeID: self.currentRecipeTypeID)
                self.recipeViewModel.getRecipeList(currentPage: self.currentPage, request: request)
            }
        }else{
            self.currentPage += 1
            if currentPage == 1{
                self.isLoading = true
            }else{
                self.isLoading = false
            }
            let request = RecipeListRequest(recipeTypeID: self.currentRecipeTypeID)
            self.recipeViewModel.getRecipeList(currentPage: self.currentPage, request: request)
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - EXTENIONS FOR RECIPE LIST VIEW MODEL DELEGATES -

extension RecipesSearchVC: RecipeListViewModelDelegate{
    
    func didReceiveRecipesList(response: RecipeListResponse) {
        self.isLoading = false
        self.newsCurrentPage = response.data?.currentPage ?? 0
        self.newsLastPage = response.data?.lastPage ?? 0
        if let list = response.data?.recipes{
            if !list.isEmpty{
                for item in list{
                    self.arrayOfRecipes.append(item)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.recipesCollectionView.reloadData()
                    self?.searchBarBackView.isHidden = false
                }
            }else{
                self.currentPage -= 1
                if arrayOfRecipes.isEmpty{
                    self.recipesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    self.recipesCollectionView.reloadData()
                }else{
                    return
                }
            }
        }
    }
    
    func didReceiveRecipesListResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.recipesCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.recipesCollectionView.reloadData()
            self.recipesCollectionView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                let request = RecipeListRequest(recipeTypeID: self.currentRecipeTypeID)
                self.recipeViewModel.getRecipeList(currentPage: self.currentPage, request: request)
            }
        }
    }
    
}

//MARK: - EXTENIONS FOR RECIPE SEARCH LIST VIEW MODEL DELEGATES -

extension RecipesSearchVC: RecipeSearchListViewModelDelegate{
    
    func didReceiveRecipeSearchList(response: RecipeListResponse) {
        self.searchingList.removeAll()
        isLoading = false
        if let list = response.data?.recipes{
            if !list.isEmpty{
                self.searchingList = list
                DispatchQueue.main.async { [weak self] in
                    self?.recipesCollectionView.reloadData()
                }
            }else{
                self.recipesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.recipesCollectionView.reloadData()
            }
        }
    }
    
    func didReceiveRecipeSearchListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isSearching = false
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension RecipesSearchVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 20 : isSearching ? searchingList.count : arrayOfRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching{
            return configureRecipeSearchCell(at: indexPath)
        }else{
            return configureRecipesCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isSearching{
            if indexPath.row == (self.arrayOfRecipes.count - 1) && self.newsCurrentPage != self.newsLastPage && self.newsCurrentPage < self.newsLastPage{
                getRecipeList()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        
        if isSearching{
            
            guard let recipeID = self.searchingList[indexPath.row].id else {return}
            guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
            recipeDetailVC.currentTitle = PisiffikStrings.recipes()
            recipeDetailVC.currentTitle = self.searchingList[indexPath.row].recipeType ?? PisiffikStrings.recipes()
            recipeDetailVC.currentID = recipeID
            recipeDetailVC.index = indexPath.row
            recipeDetailVC.delegate = self
            self.push(controller: recipeDetailVC, hideBar: true, animated: true)
            
        }else{
            guard let recipeID = self.arrayOfRecipes[indexPath.row].id else {return}
            guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
            recipeDetailVC.currentTitle = PisiffikStrings.recipes()
            recipeDetailVC.currentTitle = self.arrayOfRecipes[indexPath.row].recipeType ?? PisiffikStrings.recipes()
            recipeDetailVC.currentID = recipeID
            recipeDetailVC.index = indexPath.row
            recipeDetailVC.delegate = self
            self.push(controller: recipeDetailVC, hideBar: true, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice().userInterfaceIdiom == .pad{
            let width = recipesCollectionView.frame.size.width / 4
            return CGSize(width: width, height: 260.0)
        }else{
            let width = recipesCollectionView.frame.size.width / 2
            return CGSize(width: width, height: 260.0)
        }
    }
    
}

//MARK: - EXTENSION FOR RECIPES CELL -

extension RecipesSearchVC{
    
    private func configureRecipesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = recipesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
        if isLoading{
            cell.showLoadingView()
            
        }else{
            
            cell.hideLoadingView()
            let recipe = self.arrayOfRecipes[indexPath.row]
            cell.titleLbl.text = recipe.name ?? ""
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.chef ?? "")"
            cell.servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.servedPersons ?? 0)"
            cell.readyLbl.text = "\(PisiffikStrings.time()): \(recipe.preparationTime ?? "") \(PisiffikStrings.min())"
            
            if recipe.isFavorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if let recipeID = recipe.id,
                   let isFavorite = recipe.isFavorite {
                    
                    let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
                    if isFavorite == 0{
                        self?.favoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: indexPath.row)
                    }else{
                        self?.unFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: indexPath.row)
                    }
                    
                    if cell.favoriteBtn.isSelected{
                        cell.favoriteBtn.isSelected = false
                    }else{
                        cell.favoriteBtn.isSelected = true
                    }
                }
            }
            
        }
        
        return cell
    }
    
    private func configureRecipeSearchCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = recipesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
        if isLoading{
            cell.showLoadingView()
            
        }else{
            
            cell.hideLoadingView()
            let recipe = self.searchingList[indexPath.row]
            cell.titleLbl.text = recipe.name ?? ""
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.chef ?? "")"
            cell.servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.servedPersons ?? 0)"
            cell.readyLbl.text = "\(PisiffikStrings.time()): \(recipe.preparationTime ?? "") \(PisiffikStrings.min())"
            
            if recipe.isFavorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if let recipeID = recipe.id,
                   let isFavorite = recipe.isFavorite {
                    
                    let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
                    if isFavorite == 0{
                        self?.favoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: indexPath.row)
                    }else{
                        self?.unFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: indexPath.row)
                    }
                    
                    if cell.favoriteBtn.isSelected{
                        cell.favoriteBtn.isSelected = false
                    }else{
                        cell.favoriteBtn.isSelected = true
                    }
                }
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension RecipesSearchVC: AddToFavoriteViewModelDelegate{
    
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        if isSearching{
            self.searchingList[indexPath].isFavorite = isFavorite
            if let index = self.arrayOfRecipes.firstIndex(where: {$0.id == self.searchingList[indexPath].id}){
                self.arrayOfRecipes[index].isFavorite = isFavorite
                self.postNotificationBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite)
                self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite, at: index, indexPath: self.currentIndexPath)
            }
        }else{
            self.arrayOfRecipes[indexPath].isFavorite = isFavorite
            self.postNotificationBy(id: self.arrayOfRecipes[indexPath].id ?? 0, isFavorite: isFavorite)
            self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[indexPath].id ?? 0, isFavorite: isFavorite, at: indexPath, indexPath: self.currentIndexPath)
        }
        DispatchQueue.main.async { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToAddRecipeToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension RecipesSearchVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        guard let isFavorite = response.data?.isFavorite else {return}
        if isSearching{
            self.searchingList[indexPath].isFavorite = isFavorite
            if let index = self.arrayOfRecipes.firstIndex(where: {$0.id == self.searchingList[indexPath].id}){
                self.arrayOfRecipes[index].isFavorite = isFavorite
                self.postNotificationBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite)
                self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite, at: index, indexPath: self.currentIndexPath)
            }
        }else{
            self.arrayOfRecipes[indexPath].isFavorite = isFavorite
            self.postNotificationBy(id: self.arrayOfRecipes[indexPath].id ?? 0, isFavorite: isFavorite)
            self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[indexPath].id ?? 0, isFavorite: isFavorite, at: indexPath, indexPath: self.currentIndexPath)
        }
        DispatchQueue.main.async { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}



//MARK: - EXTENSION FOR RECIPE FAVORITE DELEGATES -

extension RecipesSearchVC: RecipeFavoritesDelegates{
    
    func didFavoriteRecipeBy(id: Int, isFavorite: Int, at index: Int,indexPath: IndexPath?) {
        if isSearching{
            self.searchingList[index].isFavorite = isFavorite
            guard let recipeIndex = self.arrayOfRecipes.firstIndex(where: {$0.id == self.searchingList[index].id}) else {return}
            self.arrayOfRecipes[recipeIndex].isFavorite = isFavorite
            self.postNotificationBy(id: self.arrayOfRecipes[recipeIndex].id ?? 0, isFavorite: isFavorite)
            self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[recipeIndex].id ?? 0, isFavorite: isFavorite, at: index, indexPath: self.currentIndexPath)
        }else{
            self.arrayOfRecipes[index].isFavorite = isFavorite
            self.postNotificationBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite)
            self.delegate?.didFavoriteRecipeBy(id: self.arrayOfRecipes[index].id ?? 0, isFavorite: isFavorite, at: index, indexPath: self.currentIndexPath)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
    }
    
    private func postNotificationBy(id: Int,isFavorite: Int){
        let userInfo : [String : Int] = [.recipeID: id,.isFavorite: isFavorite]
        NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
    }
    
}


//MARK: - EXTENSION FOR SEARCH BAR -

extension RecipesSearchVC{
    
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
                    searchBar.text = ""
                    self.recipesCollectionView.reloadData()
                }else{
                    if Network.isAvailable{
                        let request = RecipeListSearchRequest(keyword: text, searchIn: .SIMPLE, recipeTypeID: self.currentRecipeTypeID)
                        self.recipeSearchViewModel.getRecipeSearchList(request: request)
                        isSearching = true
                        isLoading = true
                        self.recipesCollectionView.reloadData()
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                    }
                }
            }else{
                isSearching = false
                searchBar.text = ""
                self.recipesCollectionView.reloadData()
            }
        }
    
}
