//
//  ProductInfoVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol ProductInfoDelegates{
    func didStartRunningCaptureSession()
}

class ProductInfoVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productDescriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var name: String = ""
    var productDescription: String = ""
    var price: String = ""
    var delegate : ProductInfoDelegates?
    
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
        productNameLbl.text = name
        productDescriptionLbl.text = productDescription
        priceLbl.text = price
        doneBtn.setTitle(PisiffikStrings.okay(), for: .normal)
    }
    
    func setUI() {
        productNameLbl.font = Fonts.boldFontsSize24
        productNameLbl.textColor = R.color.textBlackColor()
        productDescriptionLbl.font = Fonts.mediumFontsSize16
        productDescriptionLbl.textColor = R.color.textLightGrayColor()
        priceLbl.font = Fonts.boldFontsSize24
        priceLbl.textColor = R.color.textBlackColor()
        doneBtn.titleLabel?.font = Fonts.mediumFontsSize16
        doneBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        doneBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapDoneBtn(_ sender: UIButton){
        sender.showAnimation {
            self.delegate?.didStartRunningCaptureSession()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
