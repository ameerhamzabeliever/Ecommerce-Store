//
//  CheckoutVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CheckoutVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkoutTableView: UITableView!{
        didSet{
            checkoutTableView.delegate = self
            checkoutTableView.dataSource = self
            checkoutTableView.register(R.nib.checkoutPointsCell)
            checkoutTableView.register(R.nib.checkoutAmountCell)
            checkoutTableView.register(R.nib.checkoutAddressCell)
        }
    }
    @IBOutlet weak var slideToOrderLbl: UILabel!
    @IBOutlet weak var sliderBgView: UIView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var sliderEndImageView: UIImageView!
    
    //MARK: - PROPERTIES -
    
    var sliderOrigin : CGPoint!
    var currentPaymentType: String = PisiffikStrings.paymentMethod()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setupPanGestureForSlider()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.checkout()
        slideToOrderLbl.text = PisiffikStrings.slideToOrder()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        slideToOrderLbl.font = Fonts.mediumFontsSize16
        slideToOrderLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setupPanGestureForSlider(){
        self.handlePan(gestureview: self.sliderImageView)
        self.sliderOrigin = self.sliderImageView.frame.origin
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension CheckoutVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            return configureTotalAmountCell(at: indexPath)
        case 1:
            return configureAddressCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}


//MARK: - EXTENSION FOR CHECKOUT CELLS -

extension CheckoutVC{
    
    fileprivate func configureCheckoutPointsCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = checkoutTableView.dequeueReusableCell(withIdentifier: .checkoutPointsCell, for: indexPath) as! CheckoutPointsCell
        cell.titleLbl.text = PisiffikStrings.loyaltyAndDiscounts()
        cell.pointsLbl.text = PisiffikStrings.points()
        cell.availablePointsLbl.text = PisiffikStrings.availablePoints()
        cell.reedemAllLbl.text = PisiffikStrings.reedemAll()
        return cell
    }
    
    fileprivate func configureTotalAmountCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = checkoutTableView.dequeueReusableCell(withIdentifier: .checkoutAmountCell, for: indexPath) as! CheckoutAmountCell
        cell.deliveryFeeBtn.addTapGestureRecognizer { [weak self] in
            guard let customInfoAlertVC = R.storyboard.homeSB.customInfoAlertVC() else {return}
            customInfoAlertVC.alertTitle = PisiffikStrings.deliveryFee()
            self?.present(customInfoAlertVC, animated: true, completion: nil)
        }
        return cell
    }
    
    fileprivate func configureAddressCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = checkoutTableView.dequeueReusableCell(withIdentifier: .checkoutAddressCell, for: indexPath) as! CheckoutAddressCell
        cell.paymentMethodBtn.setTitle(self.currentPaymentType, for: .normal)
        cell.addressBtn.addTapGestureRecognizer { [weak self] in
            guard let deliveryAddressVC = R.storyboard.addressSB.deliveryAddressVC() else {return}
            self?.push(controller: deliveryAddressVC, hideBar: true, animated: true)
        }
        cell.paymentMethodBtn.addTapGestureRecognizer { [weak self] in
            guard let paymentMethodVC = R.storyboard.homeSB.paymentMethodVC() else {return}
            paymentMethodVC.delegates = self
            self?.push(controller: paymentMethodVC, hideBar: true, animated: true)
        }
        return cell
    }
    
}


//MARK: - EXTENSION FOR PAYMENT METHOD DELEGATES -

extension CheckoutVC: PaymentMethodDelegates{
    
    func didSelectPayment(type: String) {
        self.currentPaymentType = type
        self.checkoutTableView.reloadData()
    }
    
}


//MARK: - EXTENSION FOR UI PAN GESTURE -

extension CheckoutVC{
    
    fileprivate func handlePan(gestureview: UIView){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanGestureRecognized(sender:)))
        gestureview.addGestureRecognizer(panGesture)
    }
    
    @objc func didPanGestureRecognized(sender: UIPanGestureRecognizer){
            
        let sliderView = sender.view!
        let sliderTranslation = sender.translation(in: sliderBgView)
        
        switch sender.state{
        case .began, .changed:
            self.slideToOrderLbl.alpha = 0.0
            
            let newX = min(max(sliderView.center.x + sliderTranslation.x, sliderView.bounds.width / 2), sliderBgView.bounds.width - sliderView.bounds.width / 2)
            let newY = min(max(sliderView.center.y + sliderTranslation.y, sliderView.bounds.height / 2), sliderBgView.bounds.height - sliderView.bounds.height / 2)
            sliderView.center = CGPoint(x: newX, y: newY)
            
            sender.setTranslation(.zero, in: sliderBgView)
            
        case .ended:
            if sliderView.frame.intersects(sliderEndImageView.frame){
                UIView.animate(withDuration: 0.3) {
                    // API Call For Checkout
                    self.sliderImageView.frame.origin = self.sliderOrigin
                    self.slideToOrderLbl.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sliderImageView.frame.origin = self.sliderOrigin
                    self.slideToOrderLbl.alpha = 1.0
                }
            }
            
        default:
            break
        }
    }


    
}
