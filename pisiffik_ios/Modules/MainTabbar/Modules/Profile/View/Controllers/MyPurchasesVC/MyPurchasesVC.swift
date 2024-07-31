//
//  MyPurchasesVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class MyPurchasesVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var purchasesTableView: UITableView!{
        didSet{
            purchasesTableView.delegate = self
            purchasesTableView.dataSource = self
            purchasesTableView.register(R.nib.myPurchaseCell)
        }
    }
    @IBOutlet weak var itemTypeLbl: UILabel!
    @IBOutlet weak var itemDurationLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private var myPurchaseVM = MyPurchaseViewModel()
    private var arrayOfPurchases: [MyPurchaseList] = []
    private var isLoading: Bool = false
    private var purchaseFilter: String = ""
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        myPurchaseVM.delegate = self
        getPurchases()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.purchase()
        itemDurationLbl.text = myPurchaseVM.getFilters().first?.capitalized
        self.purchaseFilter = myPurchaseVM.getFilters().first?.capitalized ?? ""
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        itemTypeLbl.font = Fonts.mediumFontsSize12
        itemDurationLbl.font = Fonts.mediumFontsSize12
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getPurchases(){
        if Network.isAvailable{
            isLoading = true
            self.arrayOfPurchases.removeAll()
            self.purchasesTableView.reloadData()
            let request = MyPurchaseRequest(sort: self.purchaseFilter, limit: 10)
            self.myPurchaseVM.getMyPurchases(with: request)
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
    
    
    @IBAction func didTapFilterBtn(_ sender: UIButton) {
        if isLoading {return}
        switch sender.tag{
        case 0:
//            self.showFilterPopup()
            Constants.printLogs("........")
        case 1:
            self.showFilterPopup()
        default:
            Constants.printLogs("........")
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton) {
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
}

//MARK: - EXTENSION FOR MyPurchaseViewModel DELEGATES -

extension MyPurchasesVC: MyPurchaseViewModelDelegate{
    
    func didReceiveMyPurchase(response: MyPurchaseResponse) {
        self.isLoading = false
        if let purchases = response.data{
            self.arrayOfPurchases.removeAll()
            self.arrayOfPurchases = purchases
        }
        DispatchQueue.main.async { [weak self] in
            self?.purchasesTableView.reloadData()
        }
    }
    
    func didReceiveMyPurchaseResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.purchasesTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METODS -

extension MyPurchasesVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : self.arrayOfPurchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configurePurchaseCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
}



//MARK: - EXTENSION FOR PURHCASE CELL -

extension MyPurchasesVC{
    
    fileprivate func configurePurchaseCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = purchasesTableView.dequeueReusableCell(withIdentifier: .myPurchaseCell, for: indexPath) as! MyPurchaseCell
        
        if isLoading{
            cell.showSkeletonView()
            cell.isLoading = true
        }else{
            cell.hideSkeltonView()
            
            let purchase = self.arrayOfPurchases[indexPath.row]
            
            cell.arrayOfProducts = purchase.images ?? []
            cell.statusLbl.text = purchase.purchaseType ?? ""
            cell.orderNmbLbl.text = "\(purchase.orderType ?? "")(\(purchase.orderNo ?? 0))"
            cell.dateLbl.text = purchase.date
            cell.isLoading = false
            
            cell.checkStatusBtn.addTapGestureRecognizer { [weak self] in
                guard let storePurcaseVC = R.storyboard.purchaseSB.storePurchaseVC() else {return}
                storePurcaseVC.pointsID = purchase.orderNo ?? 0
                storePurcaseVC.mode = .purchase
                self?.push(controller: storePurcaseVC, hideBar: true, animated: true)
            }
        }
        
        return cell
    }
    
}

//MARK: - EXTENSION FOR FILTER POPUPS -

extension MyPurchasesVC{
    
    fileprivate func showFilterPopup(){
        guard let purchaseFilterVC = R.storyboard.profileSB.myPurchaseFilterVC() else {return}
        purchaseFilterVC.delegate = self
        self.present(purchaseFilterVC, animated: true)
    }
    
}


//MARK: - EXTENSION FOR SEARCH BY FILTER DELEGATES -


extension MyPurchasesVC: MyPurchasesFilterProtocol{
    
    func didSelectCurrent(filter: String) {
        self.itemDurationLbl.text = filter
        self.purchaseFilter = filter
        self.getPurchases()
    }
    
}
