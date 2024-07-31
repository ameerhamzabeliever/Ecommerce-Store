//
//  MyShoppingListVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import GMStepper
import ActiveLabel
import SkeletonView
import Kingfisher

class MyShoppingListVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var shoppingListTableView: UITableView!{
        didSet{
            shoppingListTableView.delegate = self
            shoppingListTableView.dataSource = self
            shoppingListTableView.register(R.nib.myShoppingCell)
        }
    }
    @IBOutlet weak var pointsLbl: ActiveLabel!{
        didSet{
            pointsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var shareBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = ShoppingListViewModel()
    private var removeProductViewModel = RemoveProductViewModel()
    private var earnPoints : Int = 0
    private var arrayOfShoppingList : [ShoppingList] = []
    private var isLoading : Bool = false{
        didSet{
            self.updateUIText()
            self.shoppingListTableView.reloadData()
        }
    }
    private var shareList : [String] = []
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        isLoading = true
        updateUIText()
        viewModel.delegate = self
        removeProductViewModel.delegate = self
        viewModel.getShoppingList()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.myShoppingList()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        pointsLbl.font = Fonts.mediumFontsSize14
        pointsLbl.textColor = R.color.textGrayColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func updateUIText(){
        if isLoading{
            self.showLoadingView()
        }else{
            self.hideLoadingView()
            setActiveLabel()
            if earnPoints == 0 {
                pointsLbl.text = ""
            }else{
                pointsLbl.text = "\(PisiffikStrings.youWillEarn()) \(earnPoints) \(PisiffikStrings.points()) \(PisiffikStrings.atPisiffik())"
            }
        }
    }
    
    private func setEmptyDataSet(){
        self.earnPoints = 0
        self.updateUIText()
        self.shoppingListTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
        self.shoppingListTableView.reloadData()
    }
    
    private func setActiveLabel(){
        let customType = ActiveType.custom(pattern: "\(earnPoints) \(PisiffikStrings.points())")
        pointsLbl.enabledTypes = [customType]
        pointsLbl.customColor[customType] = UIColor.appLightGreenColor
    }
    
    private func showLoadingView(){
        pointsLbl.showAnimatedGradientSkeleton()
    }
    
    private func hideLoadingView(){
        pointsLbl.hideSkeleton()
    }
    
    private func shareActivity(sender: UIButton){
        self.shareBtn.showLoading()
        self.shareList = []
        for list in arrayOfShoppingList {
            let shareText = "\(list.uomQuantity ?? 0) \(list.uom ?? "") \(list.name ?? "") - (\(PisiffikStrings.quantity()) \(list.shoppingListProductQuantity ?? 0))\n"
            self.shareList.append(shareText)
        }
        self.shareBtn.hideLoading()
        
        let shareVC = UIActivityViewController(activityItems: shareList, applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        shareVC.excludedActivityTypes = [.addToReadingList]
        self.present(shareVC, animated: true, completion: nil)
    
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapItemRemoveBtn(_ sender: UIButton){
        sender.showAnimation {
            if let variantID = self.arrayOfShoppingList[sender.tag].variantID{
                self.removeProductViewModel.removeProductOf(variantID: variantID, at: sender.tag)
                if self.arrayOfShoppingList.count == 1{
                    self.arrayOfShoppingList.remove(at: sender.tag)
                    self.setEmptyDataSet()
                }else{
                    self.arrayOfShoppingList.remove(at: sender.tag)
                    self.shoppingListTableView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            }
        }
    }
    
    @objc func didStepperValueChanged(_ sender: GMStepper){
        if sender.tag <= (arrayOfShoppingList.count - 1){
            guard let variantID = arrayOfShoppingList[sender.tag].variantID else {return}
            if sender.value > Double(arrayOfShoppingList[sender.tag].shoppingListProductQuantity ?? 1){
                self.viewModel.modifyProductQuantity(variantID: variantID, modifyType: 1, at: sender.tag)
            }else{
                if arrayOfShoppingList[sender.tag].shoppingListProductQuantity != 1{
                    self.viewModel.modifyProductQuantity(variantID: variantID, modifyType: 0, at: sender.tag)
                }
            }
            arrayOfShoppingList[sender.tag].shoppingListProductQuantity = Int(sender.value)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapDeleteBtn(_ sender: UIButton){
        sender.showAnimation {
            if !self.arrayOfShoppingList.isEmpty{
                if Network.isAvailable{
                    self.viewModel.clearAllShoppingList()
                    self.arrayOfShoppingList.removeAll()
                    self.setEmptyDataSet()
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain()])
                }
            }
        }
    }
    
    @IBAction func didTapShareBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.arrayOfShoppingList.isEmpty{
                self.shareActivity(sender: sender)
            }
        }
    }
    
    
}

//MARK: - EXTENSION FOR SHOPPING LIST VIEW MODEL DELEGATES -

extension MyShoppingListVC: ShoppingListViewModelDelegates{
    
    func didReceiveShoppingList(response: ShoppingListResponse) {
        isLoading = false
        if let data = response.data{
            
            if let earnPoints = data.earnablePoints{
                self.earnPoints = earnPoints
            }
            
            if let list = data.shoppingList{
                if !list.isEmpty{
                    self.arrayOfShoppingList = list
                    DispatchQueue.main.async { [weak self] in
                        self?.updateUIText()
                        self?.shoppingListTableView.reloadData()
                    }
                }else{
                    self.shoppingListTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    self.shoppingListTableView.reloadData()
                }
            }
            
        }
        
    }
    
    func didReceiveShoppingListResponseWith(error: [String]?,statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    func didReceiveClearAllShoppingList(response: BaseResponse) {
        UserDefault.shared.saveShoppingList(count: 0)
    }
    
    func didReceiveClearAllShoppingListResponseWith(error: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    func didReceiveModifyProduct(response: ModifyProductResponse, at indexPath: Int) {
        if let totalQuantity = response.data?.totalQuantity{
            UserDefault.shared.saveShoppingList(count: totalQuantity)
        }
    }
    
    func didReceiveModifyProductResponseWith(error: [String]?, statusCode: Int?) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - REMOVE PRODUCT VIEW MODEL DELEGATES -

extension MyShoppingListVC: RemoveProductViewModelDelegate{
    
    func didReceiveRemoveProduct(response: RemoveProductResponse, at indexPath: Int) {
        if let earnPoints = response.data?.earnPoints{
            self.earnPoints = earnPoints
            self.updateUIText()
            if let totalQuantity = response.data?.totalQuantity{
                UserDefault.shared.saveShoppingList(count: totalQuantity)
            }
        }
    }
    
    func didReceiveRemoveProductResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        RootRouter().logoutUserIsUnAutenticated()
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METODS -

extension MyShoppingListVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : arrayOfShoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureMyShoppingCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: -  EXTENSION FOR CART CELLS -

extension MyShoppingListVC{
    
    fileprivate func configureMyShoppingCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: .myShoppingCell, for: indexPath) as! MyShoppingCell
        
        if isLoading{
            cell.showLoaderView()
        }else{
            cell.hideLoaderView()
            let item = arrayOfShoppingList[indexPath.row]
            
            if let url = URL(string: "\(item.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            
            cell.titleLbl.text = item.name
            cell.quantityLbl.text = "\(item.uomQuantity ?? 0) \(item.uom ?? "")"
            cell.priceLbl.text = "\(item.price ?? "") \(item.currency ?? "")"
            cell.priceLbl.textColor = R.color.textBlackColor()
            if let isMember = item.isMember{
                if isMember == 0{
                    cell.rebateLbl.text = ""
                }else{
                    cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(item.afterDiscountPrice ?? "") \(item.currency ?? "")"
                }
            }
            cell.stepperView.value = Double(item.shoppingListProductQuantity ?? Int(1.0))
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(didTapItemRemoveBtn(_:)), for: .touchUpInside)
            cell.stepperView.tag = indexPath.row
            cell.stepperView.addTarget(self, action: #selector(didStepperValueChanged(_:)), for: .valueChanged)
            
        }
        
        return cell
    }
    
}
