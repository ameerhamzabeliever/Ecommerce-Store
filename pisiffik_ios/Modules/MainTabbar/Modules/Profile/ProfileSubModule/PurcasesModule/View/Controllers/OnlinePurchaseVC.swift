//
//  OnlinePurchaseVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

enum OnlineItemPurchaseStatus{
    case received
    case treatment
    case sentToStore
    case readyForPickup
    case delivered
}

class OnlinePurchaseVC: BaseVC {
    
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
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var typeNameLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var orderNmbLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var storeRedeemLbl: UILabel!
    @IBOutlet weak var storeRedeemPointsLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var deliverStackView: UIStackView!
    @IBOutlet weak var deliverDateLbl: UILabel!
    @IBOutlet weak var deliverLbl: UILabel!
    @IBOutlet weak var pickupStackView: UIStackView!
    @IBOutlet weak var pickupDateLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var sentToStackView: UIStackView!
    @IBOutlet weak var sentToDateLbl: UILabel!
    @IBOutlet weak var sentToLbl: UILabel!
    @IBOutlet weak var treatmentStackView: UIStackView!
    @IBOutlet weak var treatmentDateLbl: UILabel!
    @IBOutlet weak var treatmentLbl: UILabel!
    @IBOutlet weak var receivedStackView: UIStackView!
    @IBOutlet weak var receivedDateLbl: UILabel!
    @IBOutlet weak var receivedLbl: UILabel!
    @IBOutlet weak var statusSeperatorView: UIView!
    @IBOutlet weak var packageNmbLbl: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var deliveryToLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsEarnView: UIView!
    @IBOutlet weak var pisiffikBenifitsLbl: UILabel!
    @IBOutlet weak var earnPointsLbl: ActiveLabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var vatPriceLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var deliveryFeeLbl: UILabel!
    @IBOutlet weak var paymentRedeemLbl: UILabel!
    @IBOutlet weak var paymentRedeemPointsLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var paymentMethodNameLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    
    
    //MARK: - PROPERTIES -
    
    let earnPoints : Int = 15
    let packageNmb : String = "00370730255749175696"
    
    var itemStatusMode : OnlineItemPurchaseStatus = {
        let mode : OnlineItemPurchaseStatus = .delivered
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setItemPurchaseStatusOf(type: self.itemStatusMode)
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
        statusLbl.text = "\(PisiffikStrings.status()):"
        deliverLbl.text = PisiffikStrings.delivered()
        pickupLbl.text = PisiffikStrings.readyForPickup()
        sentToLbl.text = PisiffikStrings.sentToStore()
        treatmentLbl.text = PisiffikStrings.duringTreatment()
        receivedLbl.text = PisiffikStrings.received()
        packageNmbLbl.text = "\(PisiffikStrings.packageNumber()): \(self.packageNmb)"
        deliveryToLbl.text = "\(PisiffikStrings.deliveryTo()):"
        pisiffikBenifitsLbl.text = "\(PisiffikStrings.pisiffikBenefits()):"
        earnPointsLbl.text = "\(PisiffikStrings.youWillEarn()) \(self.earnPoints) \(PisiffikStrings.points()) \(PisiffikStrings.whenYourOrderIsCompletedSuccessfully())"
        vatLbl.text = PisiffikStrings.totalVAT()
        deliveryLbl.text = PisiffikStrings.deliveryFee()
        paymentRedeemLbl.text = PisiffikStrings.redeemPoints()
        paymentMethodLbl.text = PisiffikStrings.paymentMethod()
        totalAmountLbl.text = "\(PisiffikStrings.totalAmountDue()):"
        cancelOrderBtn.setTitle(PisiffikStrings.cancelOrder(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        storeLbl.font = Fonts.mediumFontsSize18
        storeLbl.textColor = R.color.textBlackColor()
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
        statusLbl.font = Fonts.mediumFontsSize16
        statusLbl.textColor = R.color.textBlackColor()
        deliverDateLbl.font = Fonts.mediumFontsSize12
        deliverDateLbl.textColor = R.color.textGrayColor()
        deliverLbl.font = Fonts.mediumFontsSize12
        deliverLbl.textColor = R.color.textBlackColor()
        pickupDateLbl.font = Fonts.mediumFontsSize12
        pickupDateLbl.textColor = R.color.textGrayColor()
        pickupLbl.font = Fonts.mediumFontsSize12
        pickupLbl.textColor = R.color.textBlackColor()
        sentToDateLbl.font = Fonts.mediumFontsSize12
        sentToDateLbl.textColor = R.color.textGrayColor()
        sentToLbl.font = Fonts.mediumFontsSize12
        sentToLbl.textColor = R.color.textBlackColor()
        treatmentDateLbl.font = Fonts.mediumFontsSize12
        treatmentDateLbl.textColor = R.color.textGrayColor()
        treatmentLbl.font = Fonts.mediumFontsSize12
        treatmentLbl.textColor = R.color.textBlackColor()
        receivedDateLbl.font = Fonts.mediumFontsSize12
        receivedDateLbl.textColor = R.color.textGrayColor()
        receivedLbl.font = Fonts.mediumFontsSize12
        receivedLbl.textColor = R.color.textBlackColor()
        packageNmbLbl.font = Fonts.regularFontsSize12
        packageNmbLbl.textColor = R.color.textBlackColor()
        deliveryToLbl.font = Fonts.mediumFontsSize16
        deliveryToLbl.textColor = R.color.textBlackColor()
        nameLbl.font = Fonts.mediumFontsSize12
        nameLbl.textColor = R.color.textBlackColor()
        pisiffikBenifitsLbl.font = Fonts.mediumFontsSize16
        pisiffikBenifitsLbl.textColor = R.color.textBlackColor()
        earnPointsLbl.font = Fonts.mediumFontsSize12
        earnPointsLbl.textColor = R.color.textBlackColor()
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
        cancelOrderBtn.titleLabel?.font = Fonts.mediumFontsSize16
        cancelOrderBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        cancelOrderBtn.backgroundColor = R.color.textWhiteColor()
        setActiveLabel()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setActiveLabel(){
        let customType = ActiveType.custom(pattern: "\(self.earnPoints) \(PisiffikStrings.points())")
        self.earnPointsLbl.enabledTypes = [customType]
        self.earnPointsLbl.customColor[customType] = R.color.lightGreenColor()
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
    
    
    @IBAction func didTapCancelOrderBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let customAlertVC = R.storyboard.alertSB.customAlertVC() else {return}
            customAlertVC.delegate = self
            customAlertVC.currentTitle = PisiffikStrings.cancelOrder()
            customAlertVC.currentDescription = PisiffikStrings.areYouSureYouWantToCancelThisOrder()
            self.present(customAlertVC, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension OnlinePurchaseVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureStoreInfoCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}


//MARK: - EXTENSION FOR ONLINE PURCHASE CELLS -

extension OnlinePurchaseVC{
    
    private func configureStoreInfoCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = purchaseTableView.dequeueReusableCell(withIdentifier: .onlineItemPurchaseCell, for: indexPath) as! OnlineItemPurchaseCell
        cell.itemImageView.image = R.image.ic_headphone_image()
        cell.discountedPriceLbl.attributedText = "24.99 kr.".strikeThrough()
        cell.pointsLbl.text = "\(PisiffikStrings.points()): 200"
        return cell
    }
    
}

//MARK: - EXTENSION FOR CUSTOM ALERT VC -

extension OnlinePurchaseVC: CustomAlertDelegates{
    
    func didTapOnDoneBtn(at index: Int) {
        guard let cancelOrderVC = R.storyboard.purchaseSB.cancelOrderVC() else {return}
        self.push(controller: cancelOrderVC, hideBar: true, animated: false)
    }
    
}


//MARK: - EXTENSION FOR ITEM STATUS -

extension OnlinePurchaseVC{
    
    private func setItemPurchaseStatusOf(type: OnlineItemPurchaseStatus){
        switch type {
        case .received:
            self.deliverStackView.isHidden = true
            self.pickupStackView.isHidden = true
            self.sentToStackView.isHidden = true
            self.treatmentStackView.isHidden = true
            self.receivedStackView.isHidden = false
        case .treatment:
            self.deliverStackView.isHidden = true
            self.pickupStackView.isHidden = true
            self.sentToStackView.isHidden = true
            self.treatmentStackView.isHidden = false
            self.receivedStackView.isHidden = false
        case .sentToStore:
            self.deliverStackView.isHidden = true
            self.pickupStackView.isHidden = true
            self.sentToStackView.isHidden = false
            self.treatmentStackView.isHidden = false
            self.receivedStackView.isHidden = false
        case .readyForPickup:
            self.deliverStackView.isHidden = true
            self.pickupStackView.isHidden = false
            self.sentToStackView.isHidden = false
            self.treatmentStackView.isHidden = false
            self.receivedStackView.isHidden = false
        case .delivered:
            self.deliverStackView.isHidden = false
            self.pickupStackView.isHidden = false
            self.sentToStackView.isHidden = false
            self.treatmentStackView.isHidden = false
            self.receivedStackView.isHidden = false
        }
    }
    
}
