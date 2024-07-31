//
//  RecipeFavoritesVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 18/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class RecipeFavoritesVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!{
        didSet{
            favoritesCollectionView.delegate = self
            favoritesCollectionView.dataSource = self
            favoritesCollectionView.reloadData()
            favoritesCollectionView.register(R.nib.recipesSubCell)
            favoritesCollectionView.register(R.nib.favoritesHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        }
    }
    
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = RecipeFavoritesViewModel()
    private var unFavoriteViewModel = RemoveFromFavoriteViewModel()
    private var isLoading : Bool = false
    private var arrayOfRecipies : [HomeRecipiesData] = []
    private var searchingList : [HomeRecipiesData] = []
    private var isSearching : Bool = false
    private var currentPage : Int = 0
    private var newsCurrentPage : Int = 0
    private var newsLastPage : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        unFavoriteViewModel.delegate = self
        getRecipeFavoriteList()
        self.searchBarBackView.isHidden = true
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
    
    private func navigateToRecipeDetailVC(title: String,id: Int){
        guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
        recipeDetailVC.currentTitle = title
        recipeDetailVC.currentID = id
        recipeDetailVC.delegate = self
        recipeDetailVC.mode = .byFavorites
        self.push(controller: recipeDetailVC, hideBar: true, animated: true)
    }
    
    private func getRecipeFavoriteList(){
        if !Network.isAvailable{
            self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.currentPage += 1
                if self.currentPage == 1{
                    self.isLoading = true
                }else{
                    self.isLoading = false
                }
                self.viewModel.getRecipeFavoriteList(currentPage: self.currentPage)
            }
            self.favoritesCollectionView.reloadData()
        }else{
            self.currentPage += 1
            if currentPage == 1{
                self.isLoading = true
            }else{
                self.isLoading = false
            }
            self.viewModel.getRecipeFavoriteList(currentPage: self.currentPage)
        }
    }
    
    private func didUnfavoriteRecipe(at index: Int){
        if Network.isAvailable{
            guard let recipeID = self.arrayOfRecipies[index].id else { return }
            let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
            self.unFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: index)
            self.arrayOfRecipies.remove(at: index)
            let userInfo : [String : Int] = [.recipeID : recipeID, .isFavorite : 0]
            NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
            if self.arrayOfRecipies.isEmpty{
                self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                    self?.searchBarBackView.isHidden = true
                }
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                }
            }
            
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    
    private func didUnfavoriteRecipeFromSearching(at index: Int){
        if Network.isAvailable{
            guard let recipeID = self.searchingList[index].id else { return }
            let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
            self.unFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: index)
            self.searchingList.remove(at: index)
            if let listIndex = self.arrayOfRecipies.firstIndex(where: {$0.id == recipeID}){
                self.arrayOfRecipies.remove(at: listIndex)
            }
            let userInfo : [String : Int] = [.recipeID : recipeID, .isFavorite : 0]
            NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
            if self.searchingList.isEmpty{
                self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                }
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                }
            }
            
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    //MARK: - ACTIONS -
    
    
    @objc func didSearchingList(_ textField: UITextField){
        if let text = textField.text{
            if text.isEmpty{
                isSearching = false
                textField.text = ""
                self.favoritesCollectionView.reloadData()
            }else{
//                searchingList.removeAll()
                searchingList = arrayOfRecipies.filter({$0.name?.localizedCaseInsensitiveContains(text) ?? false})
//                searchingList = arrayOfRecipies.filter({$0.name?.prefix(text.count) ?? "" == text})
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

//MARK: - EXTENSION FOR RECIPE FAVORITE VIEW MODEL DELEGATES -

extension RecipeFavoritesVC: RecipeFavoritesViewModelDelegate{
    
    
    func didReceiveRecipeFavoriteList(response: RecipeFavoriteResponse) {
        isLoading = false
        self.newsCurrentPage = response.data?.currentPage ?? 0
        self.newsLastPage = response.data?.lastPage ?? 0
        if let list = response.data?.recipes{
            if !list.isEmpty{
                for item in list{
                    if !self.arrayOfRecipies.contains(where: {$0.id == item.id}){
                        self.arrayOfRecipies.append(item)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.favoritesCollectionView.reloadData()
                    self?.searchBarBackView.isHidden = false
                }
            }else{
                self.currentPage -= 1
                if arrayOfRecipies.isEmpty{
                    self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    self.favoritesCollectionView.reloadData()
                }else{
                    return
                }
            }
        }
    }
    
    func didReceiveRecipeFavoriteListResponseWith(errorMessage: [String]?, statusCode: Int?) {
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
            self.viewModel.getRecipeFavoriteList(currentPage: self.currentPage)
        }
    }
    
    
}

//MARK: - EXTENSION FOR RECIPE FAVORITE DELEGATES -

extension RecipeFavoritesVC: RecipeFavoritesDelegates{
    
    func didFavoriteRecipeBy(id: Int, isFavorite: Int, at index: Int,indexPath: IndexPath?) {
        
        if isSearching{
            
            if isFavorite == 0{
                guard let index = self.searchingList.firstIndex(where: {$0.id == id}) else {return}
                self.searchingList.remove(at: index)
                guard let listIndex = self.arrayOfRecipies.firstIndex(where: {$0.id == id}) else {return}
                self.arrayOfRecipies.remove(at: listIndex)
                if self.searchingList.isEmpty{
                    self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    DispatchQueue.main.async { [weak self] in
                        self?.favoritesCollectionView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async { [weak self] in
                        self?.favoritesCollectionView.reloadData()
                    }
                }
            }
            
        }else{
            if isFavorite == 0{
                guard let index = self.arrayOfRecipies.firstIndex(where: {$0.id == id}) else {return}
                self.arrayOfRecipies.remove(at: index)
                if self.arrayOfRecipies.isEmpty{
                    self.searchBarBackView.isHidden = true
                    self.favoritesCollectionView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    DispatchQueue.main.async { [weak self] in
                        self?.favoritesCollectionView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async { [weak self] in
                        self?.favoritesCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension RecipeFavoritesVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
       
    }
    
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesCollectionView.reloadData()
        }
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension RecipeFavoritesVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 20 : isSearching ? searchingList.count : arrayOfRecipies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching{
            return configureSearchingRecipesCell(at: indexPath)
        }else{
            return configureRecipesCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isSearching{
            if indexPath.row == (self.arrayOfRecipies.count - 1) && self.newsCurrentPage != self.newsLastPage && self.newsCurrentPage < self.newsLastPage{
                getRecipeFavoriteList()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading { return }
        if isSearching{
            guard let recipeID = self.searchingList[indexPath.row].id , let title = self.searchingList[indexPath.row].recipe_type else {return}
            self.navigateToRecipeDetailVC(title: title, id: recipeID)
        }else{
            guard let recipeID = self.arrayOfRecipies[indexPath.row].id , let title = self.arrayOfRecipies[indexPath.row].recipe_type else {return}
            self.navigateToRecipeDetailVC(title: title, id: recipeID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.favoritesCollectionView.frame.width - 10)
        if UIDevice().userInterfaceIdiom == .phone{
            return CGSize(width: width / 2, height: 260.0)
        }else{
            return CGSize(width: width / 3, height: 260.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return configureFavoritesHeader(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.favoritesCollectionView.frame.size.width
        if !self.arrayOfRecipies.isEmpty{
            return CGSize(width: width, height: 50.0)
        }else{
            return CGSize(width: width, height: 0.0)
        }
        
    }
    
}


//MARK: - EXTENSION FOR FAVORITES CELLS -

extension RecipeFavoritesVC{
    
    private func configureRecipesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            let recipe = self.arrayOfRecipies[indexPath.row]
            cell.titleLbl.text = recipe.name ?? ""
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.chef ?? "")"
            cell.servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.servedPersons ?? 0)"
            cell.readyLbl.text = "\(PisiffikStrings.time()): \(recipe.preparationTime ?? "") \(PisiffikStrings.min())"
            
            if recipe.is_favorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                self?.didUnfavoriteRecipe(at: indexPath.row)
            }
            
        }
        
        return cell
    }
    
    private func configureSearchingRecipesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
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
            
            if recipe.is_favorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                self?.didUnfavoriteRecipeFromSearching(at: indexPath.row)
            }
            
        }
        
        return cell
    }
    
    
    fileprivate func configureFavoritesHeader(_ indexPath: IndexPath) -> UICollectionReusableView{
        let header = favoritesCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .favoritesHeaderView, for: indexPath) as! FavoritesHeaderView
        
        if isLoading{
            header.setSkeletonView()
            
        }else{
            
            header.hideSkeletonView()
            
            let customType = ActiveType.custom(pattern: "\(PisiffikStrings.favorites())")
            header.myFavoritesLbl.enabledTypes = [customType]
            header.myFavoritesLbl.customColor[customType] = R.color.textBlackColor()
            if isSearching{
                header.myFavoritesLbl.text = "\(PisiffikStrings.favorites()) (\(self.searchingList.count))"
            }else{
                header.myFavoritesLbl.text = "\(PisiffikStrings.favorites()) (\(self.arrayOfRecipies.count))"
            }
            header.gridBtn.isHidden = true
            header.listBtn.isHidden = true
        }
    
        return header
    }
    
}
