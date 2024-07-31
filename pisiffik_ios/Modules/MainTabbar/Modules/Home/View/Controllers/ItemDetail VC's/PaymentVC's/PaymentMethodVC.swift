//
//  PaymentMethodVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

struct PaymentMethodModel{
    let name: String
    let image: UIImage
}

protocol PaymentMethodDelegates{
    func didSelectPayment(type: String)
}

class PaymentMethodVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var paymentMethodTableView: UITableView!{
        didSet{
            paymentMethodTableView.delegate = self
            paymentMethodTableView.dataSource = self
            paymentMethodTableView.register(R.nib.paymentMethodCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    var delegates: PaymentMethodDelegates?
    
    let payments : [PaymentMethodModel] = [
        PaymentMethodModel(name: PisiffikStrings.cashOnDelivery(), image: R.image.ic_cash_icon()!),
        PaymentMethodModel(name: PisiffikStrings.creditOrDabitCard(), image: R.image.ic_credit_card_icon()!)
    ]
    
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
        titleLbl.text = PisiffikStrings.paymentMethod()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension PaymentMethodVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configurePaymentMethodCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.delegates?.didSelectPayment(type: PisiffikStrings.cashOnDelivery())
            self.navigationController?.popViewController(animated: true)
        }else{
            //Check if already card add go to card vc otherwise go to no card added vc
            guard let noPaymentCardVC = R.storyboard.homeSB.noPaymentCardVC() else {return}
            self.push(controller: noPaymentCardVC, hideBar: true, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR PAYMENT CELL -

extension PaymentMethodVC{
    
    fileprivate func configurePaymentMethodCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = paymentMethodTableView.dequeueReusableCell(withIdentifier: .paymentMethodCell, for: indexPath) as! PaymentMethodCell
        cell.paymentNameLbl.text = payments[indexPath.row].name
        cell.paymentImageView.image = payments[indexPath.row].image
        return cell
    }
    
}
