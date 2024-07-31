//
//  CancelOrderVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CancelOrderVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var orderInfoLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var orderNmbLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView!{
        didSet{
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
            itemsCollectionView.register(R.nib.purchaseSubCell)
        }
    }
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var reasonForLbl: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    let reasonPlaceholder : String = "please cancel - thanks"
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.cancellationRequest()
        orderInfoLbl.text = PisiffikStrings.orderInfo()
        orderDateLbl.text = "\(PisiffikStrings.orderDate()):"
        orderLbl.text = "\(PisiffikStrings.orderNo()):"
        amountLbl.text = "\(PisiffikStrings.amount()):"
        descriptionLbl.text = PisiffikStrings.cancelOrderDescription()
        reasonForLbl.text = PisiffikStrings.reasonForCancellation()
        confirmBtn.setTitle(PisiffikStrings.confirmCancellationRequest(), for: .normal)
        cancelBtn.setTitle(PisiffikStrings.cancel(), for: .normal)
        //In Case of No Reply...
        reasonTextView.text = self.reasonPlaceholder
        reasonTextView.textColor = R.color.textLightGrayColor()
        reasonTextView.delegate = self
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        orderInfoLbl.font = Fonts.mediumFontsSize18
        orderInfoLbl.textColor = R.color.textBlackColor()
        orderDateLbl.font = Fonts.mediumFontsSize12
        orderDateLbl.textColor = R.color.textGrayColor()
        dateLbl.font = Fonts.mediumFontsSize12
        dateLbl.textColor = R.color.textBlackColor()
        orderLbl.font = Fonts.mediumFontsSize12
        orderLbl.textColor = R.color.textGrayColor()
        orderNmbLbl.font = Fonts.mediumFontsSize12
        orderNmbLbl.textColor = R.color.textBlackColor()
        amountLbl.font = Fonts.mediumFontsSize12
        amountLbl.textColor = R.color.textGrayColor()
        priceLbl.font = Fonts.mediumFontsSize12
        priceLbl.textColor = R.color.textBlackColor()
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = R.color.textGrayColor()
        reasonForLbl.font = Fonts.mediumFontsSize14
        reasonForLbl.textColor = R.color.textBlackColor()
        confirmBtn.titleLabel?.font = Fonts.mediumFontsSize16
        confirmBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        confirmBtn.backgroundColor = R.color.textWhiteColor()
        cancelBtn.titleLabel?.font = Fonts.mediumFontsSize16
        cancelBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        cancelBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapConfirmBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let cancelOrderDoneVC = R.storyboard.purchaseSB.cancelOrderDoneVC() else {return}
            self.push(controller: cancelOrderDoneVC, hideBar: true, animated: false)
        }
    }
    
    @IBAction func didTapCancelBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension CancelOrderVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureItemCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.0, height: 65.0)
    }
    
}

extension CancelOrderVC{
    
    fileprivate func configureItemCell(_ indexPat: IndexPath) -> UICollectionViewCell{
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .purchaseSubCell, for: indexPat) as! PurchaseSubCell
        cell.itemsImageView.image = R.image.ic_led()
        return cell
    }
    
}



//MARK: - EXTENSION FOR TEXT VIEW DELEGATES -

extension CancelOrderVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reasonTextView.textColor == R.color.textLightGrayColor() {
            reasonTextView.text = ""
            reasonTextView.textColor = R.color.textBlackColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reasonTextView.text == "" {
            reasonTextView.text = self.reasonPlaceholder
            reasonTextView.textColor = R.color.textLightGrayColor()
        }
    }
    
}
