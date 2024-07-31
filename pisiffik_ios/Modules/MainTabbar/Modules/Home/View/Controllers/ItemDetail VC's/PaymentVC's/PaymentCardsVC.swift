//
//  PaymentCardsVC.swift
//  pisiffik_ios
//
//  Created by APPLE on 6/17/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

enum PaymentCardMode{
    case fromAddCard
    case fromCheckout
}

class PaymentCardsVC: BaseVC {
    
    //MARK: - OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardsTableView: UITableView!{
        didSet{
            cardsTableView.delegate = self
            cardsTableView.dataSource = self
            cardsTableView.register(R.nib.paymentCardCell)
        }
    }
    @IBOutlet weak var addNewCardBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var mode : PaymentCardMode = {
        let mode : PaymentCardMode = .fromCheckout
        return mode
    }()
    
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
        addNewCardBtn.setTitle(PisiffikStrings.addNewCard(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        addNewCardBtn.titleLabel?.font = Fonts.mediumFontsSize16
        addNewCardBtn.setTitleColor(.white, for: .normal)
        addNewCardBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    //MARK: - ACTIONS -
    
    @objc func didDeleteCardAtIndex(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddNewCardBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.mode == .fromCheckout{
                guard let addNewCardVC = R.storyboard.homeSB.addPaymentCardVC() else {return}
                self.push(controller: addNewCardVC, hideBar: true, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension PaymentCardsVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCardsCell(at: indexPath)
    }
    
}


//MARK: - EXTENSION FOR CARDS CELL -

extension PaymentCardsVC{
    
    fileprivate func configureCardsCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = cardsTableView.dequeueReusableCell(withIdentifier: .paymentCardCell, for: indexPath) as! PaymentCardCell
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(didDeleteCardAtIndex(_:)), for: .touchUpInside)
        return cell
    }
    
}
