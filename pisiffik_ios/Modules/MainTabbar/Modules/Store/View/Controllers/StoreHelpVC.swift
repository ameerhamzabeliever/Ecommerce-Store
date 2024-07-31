//
//  StoreHelpVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

enum AlertType{
    case General
    case CameraPermission
    case LocationPermission
    case ErrorMessage
    case phoneVerifyError
    case emailVerifyError
}

protocol StoreHelpVCDelegates{
    func didTapAlertDoneBtn(alertType: AlertType)
}

class StoreHelpVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var currentTitle : String = PisiffikStrings.instructions()
    var currentDescription : String = PisiffikStrings.scanBarcodeAndGetProductDetailsLikeProductNameBrandPricing()
    var errorDescriptions: [String]? = nil
    var isCancelBtnHide: Bool = true
    
    var type : AlertType = {
        let type : AlertType = .General
        return type
    }()
    
    var delegate : StoreHelpVCDelegates?
    
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
        titleLbl.text = self.currentTitle
        if let errors = self.errorDescriptions {
           
            for error in errors {
                self.descriptionLbl.text = error + "\n"
            }
            
        } else {
            descriptionLbl.text = self.currentDescription
        }
        
        okBtn.setTitle(PisiffikStrings.okay(), for: .normal)
        cancelBtn.setTitle(PisiffikStrings.cancel(), for: .normal)
        if isCancelBtnHide{
            cancelBtn.isHidden = true
        }else{
            cancelBtn.isHidden = false
        }
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = R.color.textBlackColor()
        descriptionLbl.font = Fonts.semiBoldFontsSize14
        descriptionLbl.textColor = R.color.textGrayColor()
        okBtn.titleLabel?.font = Fonts.mediumFontsSize16
        cancelBtn.titleLabel?.font = Fonts.mediumFontsSize16
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapOkBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.didTapAlertDoneBtn(alertType: self.type)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCancelBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
}


extension StoreHelpVCDelegates{
    func didTapAlertDoneBtn(alertType: AlertType) {}
}
