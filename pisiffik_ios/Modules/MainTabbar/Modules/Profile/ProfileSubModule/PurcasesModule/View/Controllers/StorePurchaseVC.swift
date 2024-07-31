//
//  StorePurchaseVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

enum StorePurchaseMode{
    case points
    case purchase
}

class StorePurchaseVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var purchaseTableView: ContentSizedTableView!{
        didSet{
            purchaseTableView.delegate = self
            purchaseTableView.dataSource = self
            purchaseTableView.register(R.nib.onlineItemPurchaseCell)
        }
    }
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeLbl: UILabel!{
        didSet{
            storeLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!{
        didSet{
            addressLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var phoneNmbStackView: UIStackView!
    @IBOutlet weak var phoneNmbLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var typeLbl: UILabel!{
        didSet{
            typeLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var typeNameLbl: UILabel!{
        didSet{
            typeNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var orderLbl: UILabel!{
        didSet{
            orderLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var orderNmbLbl: UILabel!{
        didSet{
            orderNmbLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var orderDateLbl: UILabel!{
        didSet{
            orderDateLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var amountLbl: UILabel!{
        didSet{
            amountLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var priceLbl: UILabel!{
        didSet{
            priceLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var storeRedeemLbl: UILabel!{
        didSet{
            storeRedeemLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var storeRedeemPointsLbl: UILabel!{
        didSet{
            storeRedeemPointsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var pointsEarnView: UIView!{
        didSet{
            pointsEarnView.isSkeletonable = true
        }
    }
    @IBOutlet weak var earnedPointsLbl: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var vatLbl: UILabel!{
        didSet{
            vatLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var vatPriceLbl: UILabel!{
        didSet{
            vatPriceLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var deliveryLbl: UILabel!{
        didSet{
            deliveryLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var deliveryFeeLbl: UILabel!{
        didSet{
            deliveryFeeLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var paymentRedeemLbl: UILabel!{
        didSet{
            paymentRedeemLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var paymentRedeemPointsLbl: UILabel!{
        didSet{
            paymentRedeemPointsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var paymentMethodLbl: UILabel!{
        didSet{
            paymentMethodLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var paymentMethodNameLbl: UILabel!{
        didSet{
            paymentMethodNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var totalAmountLbl: UILabel!{
        didSet{
            totalAmountLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var totalPriceLbl: UILabel!{
        didSet{
            totalPriceLbl.isSkeletonable = true
        }
    }
    
    
    //MARK: - PROPERTIES -
    
    var type: MyPointsEarnedType = .redeem
    private var storePurchaseVM = StorePurchaseViewModel()
    private var purchaseObj: StorePurchaseData?
    private var isLoading: Bool = false
    var pointsID: Int = 0
    
    var mode: StorePurchaseMode = {
        let mode: StorePurchaseMode = .purchase
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        storePurchaseVM.delegate = self
        self.getPurchaseDetail()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.purchase()
        typeLbl.text = "\(PisiffikStrings.type()):"
        orderLbl.text = "\(PisiffikStrings.orderNo()):"
        orderDateLbl.text = "\(PisiffikStrings.orderDate()):"
        amountLbl.text = "\(PisiffikStrings.amount()):"
        storeRedeemLbl.text = "\(PisiffikStrings.redeemPoints()):"
        earnedPointsLbl.text = "\(PisiffikStrings.youHaveEarned()) \(self.purchaseObj?.redeemPoint ?? 0) \(PisiffikStrings.points())"
        vatLbl.text = PisiffikStrings.totalVAT()
        deliveryLbl.text = PisiffikStrings.deliveryFee()
        paymentRedeemLbl.text = PisiffikStrings.redeemPoints()
        paymentMethodLbl.text = PisiffikStrings.paymentMethod()
        totalAmountLbl.text = "\(PisiffikStrings.totalAmountDue()):"
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        storeLbl.font = Fonts.mediumFontsSize18
        storeLbl.textColor = R.color.textBlackColor()
        addressLbl.font = Fonts.mediumFontsSize12
        addressLbl.textColor = R.color.textBlackColor()
        phoneNmbLbl.font = Fonts.mediumFontsSize12
        phoneNmbLbl.textColor = R.color.textBlackColor()
        typeLbl.font = Fonts.mediumFontsSize12
        typeLbl.textColor = R.color.textGrayColor()
        typeNameLbl.font = Fonts.mediumFontsSize12
        typeNameLbl.textColor = R.color.textBlackColor()
        orderLbl.font = Fonts.mediumFontsSize12
        orderLbl.textColor = R.color.textGrayColor()
        orderNmbLbl.font = Fonts.mediumFontsSize12
        orderNmbLbl.textColor = R.color.textBlackColor()
        orderDateLbl.font = Fonts.mediumFontsSize12
        orderDateLbl.textColor = R.color.textGrayColor()
        dateLbl.font = Fonts.mediumFontsSize12
        dateLbl.textColor = R.color.textBlackColor()
        amountLbl.font = Fonts.mediumFontsSize12
        amountLbl.textColor = R.color.textGrayColor()
        priceLbl.font = Fonts.mediumFontsSize12
        priceLbl.textColor = R.color.textBlackColor()
        storeRedeemLbl.font = Fonts.mediumFontsSize12
        storeRedeemLbl.textColor = R.color.textGrayColor()
        storeRedeemPointsLbl.font = Fonts.mediumFontsSize12
        storeRedeemPointsLbl.textColor = R.color.textBlackColor()
        earnedPointsLbl.font = Fonts.boldFontsSize16
        earnedPointsLbl.textColor = R.color.textWhiteColor()
        vatLbl.font = Fonts.regularFontsSize12
        vatLbl.textColor = R.color.textGrayColor()
        vatPriceLbl.font = Fonts.regularFontsSize12
        vatPriceLbl.textColor = R.color.textGrayColor()
        deliveryLbl.font = Fonts.regularFontsSize12
        deliveryLbl.textColor = R.color.textGrayColor()
        deliveryFeeLbl.font = Fonts.regularFontsSize12
        deliveryFeeLbl.textColor = R.color.textGrayColor()
        paymentRedeemLbl.font = Fonts.regularFontsSize12
        paymentRedeemLbl.textColor = R.color.textGrayColor()
        paymentRedeemPointsLbl.font = Fonts.regularFontsSize12
        paymentRedeemPointsLbl.textColor = R.color.textGrayColor()
        paymentMethodLbl.font = Fonts.regularFontsSize12
        paymentMethodLbl.textColor = R.color.textGrayColor()
        paymentMethodNameLbl.font = Fonts.regularFontsSize12
        paymentMethodNameLbl.textColor = R.color.textGrayColor()
        totalAmountLbl.font = Fonts.mediumFontsSize14
        totalAmountLbl.textColor = R.color.textBlackColor()
        totalPriceLbl.font = Fonts.mediumFontsSize14
        totalPriceLbl.textColor = R.color.textBlueColor()
        if self.type == .redeem{
            self.pointsEarnView.isHidden = true
        }else{
            self.pointsEarnView.isHidden = false
        }
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getPurchaseDetail(){
        if Network.isAvailable{
            isLoading = true
            self.purchaseTableView.reloadData()
            self.showSkeletonView()
            self.storePurchaseVM.getStorePurchaseDetail(with: self.pointsID,mode: self.mode)
        }else{
            AlertController.showAlert(title: PisiffikStrings.alert(), message: PisiffikStrings.oopsNoInternetConnection(), inVC: self)
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
}

//MARK: - EXTENSION FOR StorePurchaseViewModel DELEGATES -

extension StorePurchaseVC: StorePurchaseViewModelDelegate{
    
    func didReceiveStorePurchase(response: StorePurchaseResponse) {
        isLoading = false
        if let purchaseObj = response.data{
            self.purchaseObj = purchaseObj
        }
        DispatchQueue.main.async { [weak self] in
            self?.setViewsValue()
            self?.hideSkeletonView()
            self?.purchaseTableView.reloadData()
        }
    }
    
    func didReceiveStorePurchaseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.purchaseTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension StorePurchaseVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 2 : self.purchaseObj?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureItemsPurchasedCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}


//MARK: - EXTENSION FOR ONLINE PURCHASE CELLS -

extension StorePurchaseVC{
    
    private func configureItemsPurchasedCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = purchaseTableView.dequeueReusableCell(withIdentifier: .onlineItemPurchaseCell, for: indexPath) as! OnlineItemPurchaseCell
        
        if isLoading{
            cell.showSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let item = self.purchaseObj?.items?[indexPath.row]
            cell.itemNameLbl.text = item?.name
            if let imageURL = URL(string: item?.image ?? ""){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            cell.currentPriceLbl.text = "\(item?.salePrice ?? 0) kr."
            cell.discountedPriceLbl.attributedText = "\(item?.itemPrice ?? 0) kr.".strikeThrough()
            cell.pointsLbl.text = "\(PisiffikStrings.points()): \(item?.points ?? 0)"
        }
        
        return cell
    }
    
}

//MARK: - EXTTESION FOR SKELETONN VIEW -

extension StorePurchaseVC{
    
    private func setViewsValue(){
        self.storeLbl.text = "\(PisiffikStrings.store()): \(self.purchaseObj?.storeId ?? 0)"
        self.addressLbl.text = self.purchaseObj?.address
        self.typeNameLbl.text = self.purchaseObj?.type
        self.orderNmbLbl.text = "\(self.purchaseObj?.orderNo ?? 0)"
        self.dateLbl.text = self.purchaseObj?.orderDate
        self.priceLbl.text = "\(self.purchaseObj?.amount ?? 0) kr."
        self.storeRedeemPointsLbl.text = "\(self.purchaseObj?.redeemPoint ?? 0) kr."
        self.earnedPointsLbl.text = "\(PisiffikStrings.youHaveEarned()) \(self.purchaseObj?.redeemPoint ?? 0) \(PisiffikStrings.points())"
        self.vatPriceLbl.text = "\(self.purchaseObj?.amount ?? 0) kr."
        self.deliveryFeeLbl.text = ""
        self.paymentRedeemPointsLbl.text = "\(self.purchaseObj?.redeemPoint ?? 0) kr."
        self.paymentMethodNameLbl.text = ""
        self.totalPriceLbl.text = ""
    }
    
    private func showSkeletonView(){
        storeLbl.showAnimatedGradientSkeleton()
        addressImageView.isHidden = true
        addressLbl.showAnimatedGradientSkeleton()
        typeLbl.showAnimatedGradientSkeleton()
        typeNameLbl.showAnimatedGradientSkeleton()
        orderLbl.showAnimatedGradientSkeleton()
        orderNmbLbl.showAnimatedGradientSkeleton()
        orderDateLbl.showAnimatedGradientSkeleton()
        dateLbl.showAnimatedGradientSkeleton()
        amountLbl.showAnimatedGradientSkeleton()
        priceLbl.showAnimatedGradientSkeleton()
        storeRedeemLbl.showAnimatedGradientSkeleton()
        storeRedeemPointsLbl.showAnimatedGradientSkeleton()
        pointsEarnView.showAnimatedGradientSkeleton()
        earnedPointsLbl.isHidden = true
        vatLbl.showAnimatedGradientSkeleton()
        vatPriceLbl.showAnimatedGradientSkeleton()
        deliveryLbl.showAnimatedGradientSkeleton()
        deliveryFeeLbl.showAnimatedGradientSkeleton()
        paymentRedeemLbl.showAnimatedGradientSkeleton()
        paymentRedeemPointsLbl.showAnimatedGradientSkeleton()
        paymentMethodLbl.showAnimatedGradientSkeleton()
        paymentMethodNameLbl.showAnimatedGradientSkeleton()
        totalAmountLbl.showAnimatedGradientSkeleton()
        totalPriceLbl.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeletonView(){
        storeLbl.hideSkeleton()
        addressImageView.isHidden = false
        addressLbl.hideSkeleton()
        typeLbl.hideSkeleton()
        typeNameLbl.hideSkeleton()
        orderLbl.hideSkeleton()
        orderNmbLbl.hideSkeleton()
        orderDateLbl.hideSkeleton()
        dateLbl.hideSkeleton()
        amountLbl.hideSkeleton()
        priceLbl.hideSkeleton()
        storeRedeemLbl.hideSkeleton()
        storeRedeemPointsLbl.hideSkeleton()
        pointsEarnView.hideSkeleton()
        earnedPointsLbl.isHidden = false
        vatLbl.hideSkeleton()
        vatPriceLbl.hideSkeleton()
        deliveryLbl.hideSkeleton()
        deliveryFeeLbl.hideSkeleton()
        paymentRedeemLbl.hideSkeleton()
        paymentRedeemPointsLbl.hideSkeleton()
        paymentMethodLbl.hideSkeleton()
        paymentMethodNameLbl.hideSkeleton()
        totalAmountLbl.hideSkeleton()
        totalPriceLbl.hideSkeleton()
    }
    
}
