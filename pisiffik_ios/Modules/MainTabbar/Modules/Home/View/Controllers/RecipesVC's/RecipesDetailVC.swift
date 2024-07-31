//
//  RecipesDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView
import SYBadgeButton

protocol RecipeFavoritesDelegates{
    func didFavoriteRecipeBy(id: Int,isFavorite: Int,at index: Int,indexPath: IndexPath?)
}

enum RecipeDetailMode{
    case byDefault
    case byFavorites
    case byNotifications
}

class RecipesDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var addShoppingBtn: LoadingButton!
    @IBOutlet weak var recipeImageView: UIImageView!{
        didSet{
            recipeImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.isSkeletonable = true
            favoriteBtn.setImage(R.image.ic_recipe_unfavorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_recipe_favorite_icon(), for: .selected)
        }
    }
    @IBOutlet weak var ingredientsLbl: UILabel!{
        didSet{
            ingredientsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var recipeNameLbl: UILabel!{
        didSet{
            recipeNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var basketBtn: UIButton!{
        didSet{
            basketBtn.isSkeletonable = true
            basketBtn.isUserInteractionEnabled = false
            basketBtn.setTitleColor(R.color.darkGrayColor(), for: .normal)
            basketBtn.setTitleColor(R.color.lightBlueColor(), for: .selected)
        }
    }
    @IBOutlet weak var itemsTableView: ContentSizedTableView!{
        didSet{
            itemsTableView.delegate = self
            itemsTableView.dataSource = self
            itemsTableView.register(R.nib.recipeItemCell)
        }
    }
    @IBOutlet weak var courseLbl: UILabel!{
        didSet{
            courseLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var courseDescriptionLbl: UILabel!{
        didSet{
            courseDescriptionLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var madeByLbl: UILabel!{
        didSet{
            madeByLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var readyInLbl: UILabel!{
        didSet{
            readyInLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var servingLbl: UILabel!{
        didSet{
            servingLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var readyInIcon: UIImageView!{
        didSet{
            readyInIcon.isSkeletonable = true
        }
    }
    @IBOutlet weak var servingIcon: UIImageView!{
        didSet{
            servingIcon.isSkeletonable = true
        }
    }
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var tipDetailLbl: UILabel!
    @IBOutlet weak var courseView: UIView!{
        didSet{
            courseView.isSkeletonable = true
        }
    }
    @IBOutlet weak var tipView: UIView!{
        didSet{
            tipView.isSkeletonable = true
        }
    }
    @IBOutlet weak var shoppingListBtn: SYBadgeButton!
    @IBOutlet weak var checkAllBtn: UIButton!{
        didSet{
            checkAllBtn.setImage(R.image.ic_unselect_item_icon(), for: .normal)
            checkAllBtn.setImage(R.image.ic_select_item_icon(), for: .selected)
            checkAllBtn.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var recipeHeightConstrain: NSLayoutConstraint!{
        didSet{
            if UIDevice().userInterfaceIdiom == .pad {
                recipeHeightConstrain.constant = 420
            }else{
                recipeHeightConstrain.constant = 240
            }
        }
    }
    
    //MARK: - PROPERTIES -
    
    var viewModel : RecipiesDetailViewModel = RecipiesDetailViewModel()
    private var addToShoppingViewModel = AddToShoppingListViewModel()
    private var addToFavoriteViewModel = AddToFavoriteViewModel()
    private var removeFavoriteViewModel = RemoveFromFavoriteViewModel()
    var recipe : RecipeDetailData = RecipeDetailData()
    var ingredients : [RecipeDetailIngredient] = []
    
    private var isLoading : Bool = false
    var currentID : Int = 0
    var currentTitle: String?
    var items : [RecipeItems] = []
    var cartItems : [RecipeItems] = []
    var delegate : RecipeFavoritesDelegates?
    var index : Int = 0
    
    var mode : RecipeDetailMode = {
        let mode : RecipeDetailMode = .byDefault
        return mode
    }()
    var isFavorite : Int = 0
    var isFavoriteChanged : Bool = false
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.viewModel.delegate = self
        self.addToShoppingViewModel.delegate = self
        self.addToFavoriteViewModel.delegate = self
        self.removeFavoriteViewModel.delegate = self
        getRecipeDetail()
        checkAllBtn.isSelected = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shoppingListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        UserDefault.shared.saveRecipeDetailVC(open: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefault.shared.saveRecipeDetailVC(open: false)
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        if let currentTitle = currentTitle {
            titleLbl.text = currentTitle
        }
        addShoppingBtn.setTitle(PisiffikStrings.addToShoppingList(), for: .normal)
        footerView.layer.cornerRadius = 20.0
        footerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        recipeNameLbl.font = Fonts.mediumFontsSize24
        recipeNameLbl.textColor = R.color.textBlackColor()
        basketBtn.titleLabel?.font = Fonts.semiBoldFontsSize16
        ingredientsLbl.font = Fonts.mediumFontsSize16
        ingredientsLbl.textColor = R.color.textBlackColor()
        courseLbl.font = Fonts.mediumFontsSize16
        courseLbl.textColor = R.color.textBlackColor()
        courseDescriptionLbl.font = Fonts.regularFontsSize14
        courseDescriptionLbl.textColor = R.color.textGrayColor()
        tipLbl.font = Fonts.mediumFontsSize16
        tipLbl.textColor = R.color.textBlackColor()
        tipDetailLbl.font = Fonts.regularFontsSize14
        tipDetailLbl.textColor = R.color.textGrayColor()
        madeByLbl.font = Fonts.regularFontsSize14
        madeByLbl.textColor = R.color.textGrayColor()
        readyInLbl.font = Fonts.regularFontsSize12
        readyInLbl.textColor = R.color.textGrayColor()
        servingLbl.font = Fonts.regularFontsSize12
        servingLbl.textColor = R.color.textGrayColor()
        addShoppingBtn.titleLabel?.font = Fonts.mediumFontsSize16
        addShoppingBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        addShoppingBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func updateUIText(){
        if isLoading{
            self.showLoadingView()
        }else{
            self.hideLoadingView()
            recipeNameLbl.text = recipe.recipeDetail?.name
            ingredientsLbl.text = "\(PisiffikStrings.ingrediants()):"
            courseLbl.text = PisiffikStrings.courseOfAction()
            courseDescriptionLbl.text = recipe.instructions
            tipLbl.text = PisiffikStrings.tip()
            tipDetailLbl.text = recipe.tips
            madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.recipeDetail?.chef ?? "")"
            readyInLbl.text = "\(PisiffikStrings.time()): \(recipe.recipeDetail?.preparationTime ?? "") \(PisiffikStrings.min())"
            servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.recipeDetail?.servedPersons ?? 0)"
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.recipeDetail?.image ?? "")"){
                recipeImageView.kf.indicatorType = .activity
                recipeImageView.kf.setImage(with: url)
            }
            
            if let isFavorite = recipe.recipeDetail?.isFavorite{
                if isFavorite == 1{
                    self.favoriteBtn.isSelected = true
                }else{
                    self.favoriteBtn.isSelected = false
                }
            }else{
                self.favoriteBtn.isSelected = false
            }
        }
    
    }
    
    private func showLoadingView(){
        recipeImageView.showAnimatedGradientSkeleton()
        favoriteBtn.showAnimatedGradientSkeleton()
        ingredientsLbl.showAnimatedGradientSkeleton()
        recipeNameLbl.showAnimatedGradientSkeleton()
        basketBtn.showAnimatedGradientSkeleton()
        courseLbl.showAnimatedGradientSkeleton()
        courseDescriptionLbl.showAnimatedGradientSkeleton()
        madeByLbl.showAnimatedGradientSkeleton()
        readyInLbl.showAnimatedGradientSkeleton()
        servingLbl.showAnimatedGradientSkeleton()
        readyInIcon.showAnimatedGradientSkeleton()
        servingIcon.showAnimatedGradientSkeleton()
        courseView.showAnimatedGradientSkeleton()
        tipView.showAnimatedGradientSkeleton()
        checkAllBtn.showAnimatedGradientSkeleton()
        seperatorView.isHidden = true
    }
    
    private func hideLoadingView(){
        recipeImageView.hideSkeleton()
        favoriteBtn.hideSkeleton()
        ingredientsLbl.hideSkeleton()
        recipeNameLbl.hideSkeleton()
        basketBtn.hideSkeleton()
        courseLbl.hideSkeleton()
        courseDescriptionLbl.hideSkeleton()
        madeByLbl.hideSkeleton()
        readyInLbl.hideSkeleton()
        servingLbl.hideSkeleton()
        readyInIcon.hideSkeleton()
        servingIcon.hideSkeleton()
        courseView.hideSkeleton()
        tipView.hideSkeleton()
        checkAllBtn.hideSkeleton()
        seperatorView.isHidden = false
    }
    
    private func getShoppingListRequestItems(list: [RecipeItems]) -> [AddToShoppingListRequest]{
        var shoppingList : [AddToShoppingListRequest] = []
        if let recipeID = self.recipe.recipeDetail?.id{
            for list in list {
                let item = AddToShoppingListRequest(recipeID: recipeID, variantID: list.id, uomQuantity: list.uomQuantity)
                shoppingList.append(item)
            }
        }
        return shoppingList
    }
    
    private func getRecipeDetail(){
        isLoading = true
        updateUIText()
        if Network.isAvailable{
            self.viewModel.getRecipeDetail(id: self.currentID)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            if self.mode == .byFavorites && self.isFavoriteChanged{
                self.delegate?.didFavoriteRecipeBy(id: self.currentID, isFavorite: self.isFavorite, at: self.index, indexPath: nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddToShoppingListBtn(_ sender: UIButton){
        sender.showAnimation {
            if Network.isAvailable{
                if !self.addShoppingBtn.isAnimating{
                    if !self.cartItems.isEmpty{
                        self.addShoppingBtn.showLoading()
                        let requestList = self.getShoppingListRequestItems(list: self.cartItems)
                        self.addToShoppingViewModel.addProductsToShopping(list: requestList, indexPath: self.index)
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.selectProductsFromIngredients()])
                    }
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapFavoriteBtn(_ sender: UIButton) {
        sender.showAnimation {
            if Network.isAvailable{
                guard let recipeID = self.recipe.recipeDetail?.id else {return}
                let request = AddRecipeToFavoriteRequest(recipeID: recipeID)
                if self.favoriteBtn.isSelected{
                    self.removeFavoriteViewModel.removeRecipeFromFavoriteList(request: request, indexPath: self.index)
                    self.favoriteBtn.isSelected = false
                }else{
                    self.addToFavoriteViewModel.addRecipeToFavoriteList(request: request, indexPath: self.index)
                    self.favoriteBtn.isSelected = true
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapShoppingListBtn(_ sender: SYBadgeButton) {
        sender.showAnimation {
            if Network.isAvailable{
                guard let shoppingListVC = R.storyboard.homeSB.myShoppingListVC() else {return}
                self.push(controller: shoppingListVC, hideBar: true, animated: true)
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapCheckAllBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.items.isEmpty{
                if self.checkAllBtn.isSelected{
                    self.checkAllBtn.isSelected = false
                    self.cartItems.removeAll()
                    for index in (0...self.items.count - 1){
                        self.items[index].isSelected = false
                    }
                    self.itemsTableView.reloadData()
                    self.basketBtn.isSelected = false
                    self.basketBtn.setTitle("(\(self.cartItems.count))", for: .normal)
                }else{
                    self.cartItems.removeAll()
                    self.checkAllBtn.isSelected = true
                    for index in (0...self.items.count - 1){
                        self.cartItems.append(self.items[index])
                        self.items[index].isSelected = true
                    }
                    self.itemsTableView.reloadData()
                    self.basketBtn.isSelected = true
                    self.basketBtn.setTitle("(\(self.cartItems.count))", for: .normal)
                }
            }
        }
    }
    
}

//MARK: - EXTENSION FOR RECIPES DETAIL VIEW MODEL -

extension RecipesDetailVC: RecipiesDetailViewModelDelegate{
    
    func didReceiveRecipesDetail(response: RecipeDetailResponse) {
        self.isLoading = false
        if let data = response.data?.recipe{
            self.recipe = data
            if let ingredients = response.data?.recipe?.ingredients{
                self.ingredients = ingredients
                for ingredient in ingredients {
                    let item = RecipeItems(id: ingredient.id ?? 0, name: ingredient.name ?? "", recipeQuantity: ingredient.recipeQuantity ?? 0, uomQuantity: ingredient.uomQuantity ?? 0, uom: ingredient.uom ?? "", recipeUom: ingredient.recipeUom ?? "", isSelected: false)
                    self.items.append(item)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.updateUIText()
                    self?.itemsTableView.reloadData()
                }
            }
        }
    }
    
    func didReceiveRecipesDetailResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR ADD TO SHOPPING LIST VIEW MODEL -

extension RecipesDetailVC: AddToShoppingListViewModelDelegate{
    
    func didAddToShoppingList(response: AddPisiffikProductToShoppingResponse) {
        addShoppingBtn.hideLoading()
        if let totalQuantity = response.data?.totalQuantity{
            UserDefault.shared.saveShoppingList(count: totalQuantity)
            self.shoppingListBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getShoppingListCount())
        }
        self.showAlert(title: PisiffikStrings.success(), description: response.message ?? "", delegate: self)
    }
    
    func didFailToAddToShoppingListWith(error: [String]?, at IndexPath: Int) {
        addShoppingBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR ADD TO FAVORITE VIEW MODEL -

extension RecipesDetailVC: AddToFavoriteViewModelDelegate{
    
    func didAddRecipeToFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        if let recipeID = self.recipe.recipeDetail?.id , let isFavorite = response.data?.isFavorite{
            if mode == .byDefault{
                self.delegate?.didFavoriteRecipeBy(id: recipeID, isFavorite: isFavorite, at: self.index,indexPath: nil)
            }else if mode == .byNotifications{
                let userInfo : [String: Int] = [.recipeID: recipeID, .isFavorite: isFavorite]
                NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
            }else{
                self.isFavorite = isFavorite
                self.isFavoriteChanged = true
            }
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
        
    }
    
    func didFailToAddRecipeToFavoriteListWith(error: [String]?, at IndexPath: Int) {
        self.favoriteBtn.isSelected = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR REMOVE FROM FAVORITE VIEW MODEL -

extension RecipesDetailVC: RemoveFromFavoriteViewModelDelegate{
    
    func didRemoveRecipeFromFavoriteList(response: AddToFavoriteResponse, at indexPath: Int) {
        if let recipeID = self.recipe.recipeDetail?.id , let isFavorite = response.data?.isFavorite{
            if mode == .byDefault{
                self.delegate?.didFavoriteRecipeBy(id: recipeID, isFavorite: isFavorite, at: self.index,indexPath: nil)
            }else if mode == .byNotifications{
                let userInfo : [String: Int] = [.recipeID: recipeID, .isFavorite: isFavorite]
                NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
            }else{
                self.isFavoriteChanged = true
                self.isFavorite = isFavorite
                let userInfo : [String: Int] = [.recipeID: recipeID, .isFavorite: isFavorite]
                NotificationCenter.default.post(name: .recipeFavoriteListUpdate, object: nil, userInfo: userInfo)
            }
        }
//        self.showAlert(title: PisiffikStrings.success(), errorMessages: [response.message ?? ""])
    }
    
    func didFailToRemoveRecipeFromFavoriteListWith(error: [String]?, at IndexPath: Int) {
        self.favoriteBtn.isSelected = true
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension RecipesDetailVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 0 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureRecipeItemCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isLoading {return}
        
        if cartItems.contains(where: {$0.id == items[indexPath.row].id}){
            if let cartIndex = cartItems.firstIndex(where: {$0.id == items[indexPath.row].id}){
                cartItems.remove(at: cartIndex)
            }
        }else{
            cartItems.append(items[indexPath.row])
        }
        
        if cartItems.count > 0{
            self.basketBtn.isSelected = true
            self.basketBtn.setTitle("(\(cartItems.count))", for: .normal)
        }else{
            self.basketBtn.isSelected = false
            self.basketBtn.setTitle("(\(cartItems.count))", for: .normal)
        }
        
        if cartItems.count == items.count{
            self.checkAllBtn.isSelected = true
        }else{
            self.checkAllBtn.isSelected = false
        }
        
        if items[indexPath.row].isSelected{
            items[indexPath.row].isSelected = false
        }else{
            items[indexPath.row].isSelected = true
        }
        self.itemsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

//MARK: - EXTENSION FOR RECIPE ITEM CELL -

extension RecipesDetailVC{
    
    fileprivate func configureRecipeItemCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: .recipeItemCell, for: indexPath) as! RecipeItemCell
        
        if isLoading{
//            cell.showLoadingView()
        }else{
//            cell.hideLoadingView()
            
            cell.bgView.backgroundColor = .white
            cell.itemNameLbl.text = "\(items[indexPath.row].recipeQuantity) \(items[indexPath.row].recipeUom) \(items[indexPath.row].name)"
            cell.itemNameLbl.textColor = R.color.textGrayColor()
            cell.itemSelectionImage.isHidden = false
            if items[indexPath.row].isSelected{
                cell.itemSelectionImage.image = R.image.ic_select_item_icon()
            }else{
                cell.itemSelectionImage.image = R.image.ic_unselect_item_icon()
            }
            
        }
        
        return cell
    }
    
}



//MARK: - EXTENSION FOR ALERT VC DELEGATES -

extension RecipesDetailVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        
    }
    
}
