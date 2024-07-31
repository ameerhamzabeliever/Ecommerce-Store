//
//  MyMembershipCardVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol MyMembershipCardDelegates{
    func didUpdateCaptureSession()
}

class MyMembershipCardVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var membershipCardImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cardNmbLbl: UILabel!
    @IBOutlet weak var loyalityNmbLbl: UILabel!
    @IBOutlet weak var storeImageConstrain: NSLayoutConstraint!
    
    //MARK: - PROPERTIES -
    
    var membershipCard : UIImage = UIImage()
    var delegate : MyMembershipCardDelegates?
    var cardNmb : String = ""
    var loyalityNmb : String = ""
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.backView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.didUpdateCaptureSession()
            self?.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        self.storeImageView.image = R.image.ic_pisiffik_image()
        if let user = DBUserManagerRepository().getUser(){
            self.nameLbl.text = user.fullName ?? ""
        }
        self.cardNmbLbl.text = "\(PisiffikStrings.cardNo()): \(self.cardNmb)"
        membershipCardImage.image = self.membershipCard
        if !self.cardNmb.isEmpty{
            var loyality: String = ""
            for index in (0..<cardNmb.count){
                if index != (cardNmb.count - 1){
                    loyality += "\(cardNmb[index])    "
                }else{
                    loyality += "\(cardNmb[index])"
                }
            }
            self.loyalityNmbLbl.text = loyality
        }
    }
    
    func setUI() {
        nameLbl.font = Fonts.boldFontsSize11
        nameLbl.textColor = R.color.textBlackColor()
        cardNmbLbl.font = Fonts.boldFontsSize11
        cardNmbLbl.textColor = R.color.textBlackColor()
        if UIDevice().userInterfaceIdiom == .pad{
            self.storeImageConstrain.constant = 120.0
            self.membershipCardImage.contentMode = .scaleAspectFill
        }else{
            self.storeImageConstrain.constant = 60.0
            self.membershipCardImage.contentMode = .scaleAspectFit
        }
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    
    
}
