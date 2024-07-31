//
//  MyCartVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import GMStepper
import ActiveLabel

struct MyCartModel{
    let image : UIImage
    let name : String
    let quantity : String
    let price : String
    var stepperValue : Double
}


class MyCartVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var cartTableView: UITableView!{
        didSet{
            cartTableView.delegate = self
            cartTableView.dataSource = self
            cartTableView.register(R.nib.myCartCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    var items : [MyCartModel] = [
        MyCartModel(image: (((R.image.ic_headphone_image()) ?? UIImage(named: "ic_headphone_image"))!), name: "Sony WH-1000XM4", quantity: "1 pcs", price: "1.95 kr.", stepperValue: 2.0),
        MyCartModel(image: (((R.image.ic_headphone_image()) ?? UIImage(named: "ic_headphone_image"))!), name: "Sony WH-1000XM4", quantity: "1 pcs", price: "4.45 kr.", stepperValue: 1.0)
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
        titleLbl.text = PisiffikStrings.myCart()
        checkoutBtn.setTitle(PisiffikStrings.goToCheckout(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        checkoutBtn.titleLabel?.font = Fonts.mediumFontsSize16
        checkoutBtn.setTitleColor(.white, for: .normal)
        checkoutBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapItemRemoveBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @objc func didStepperValueChanged(_ sender: GMStepper){
        items[sender.tag].stepperValue = sender.value
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapDeleteBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapCheckoutBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let checkoutVC = R.storyboard.homeSB.checkoutVC() else {return}
            self.push(controller: checkoutVC, hideBar: true, animated: true)
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METODS -

extension MyCartVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureMyCartCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: -  EXTENSION FOR CART CELLS -

extension MyCartVC{
    
    fileprivate func configureMyCartCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = cartTableView.dequeueReusableCell(withIdentifier: .myCartCell, for: indexPath) as! MyCartCell
        cell.itemImageView.image = items[indexPath.row].image
        cell.titleLbl.text = items[indexPath.row].name
        cell.quantityLbl.text = items[indexPath.row].quantity
        cell.priceLbl.text = items[indexPath.row].price
        cell.stepperView.value = items[indexPath.row].stepperValue
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(didTapItemRemoveBtn(_:)), for: .touchUpInside)
        cell.stepperView.tag = indexPath.row
        cell.stepperView.addTarget(self, action: #selector(didStepperValueChanged(_:)), for: .valueChanged)
        return cell
    }
    
}
