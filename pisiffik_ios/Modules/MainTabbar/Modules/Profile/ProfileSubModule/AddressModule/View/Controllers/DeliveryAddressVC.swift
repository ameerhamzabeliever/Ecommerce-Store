//
//  DeliveryAddressVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class DeliveryAddressVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addressTableView: UITableView!{
        didSet{
            addressTableView.delegate = self
            addressTableView.dataSource = self
            addressTableView.register(R.nib.addressCell)
        }
    }
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = AddressListViewModel()
    private var addressList : [AddressList] = []
    private var isLoading : Bool = false{
        didSet{
            addressTableView.reloadData()
        }
    }
    
    var currentIndex = -1{
        didSet{
            self.addressTableView.reloadData()
        }
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        isLoading = true
        viewModel.getAddress()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveBtn.isHidden = true
        self.currentIndex = -1
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.deliveryAddress()
        addAddressBtn.setTitle(PisiffikStrings.addNewAddress(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        addAddressBtn.titleLabel?.font = Fonts.mediumFontsSize16
        addAddressBtn.setTitleColor(.white, for: .normal)
        addAddressBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func navigateToEditAddressVC(mode: AddAddressMode){
        guard let addAddressVC = R.storyboard.addressSB.addAddressVC() else {return}
        addAddressVC.mode = mode
        self.push(controller: addAddressVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddAddressBtn(_ sender: UIButton){
        sender.showAnimation {
            if !self.isLoading{
                self.navigateToEditAddressVC(mode: .none)
            }
        }
    }
    
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    
}

//MARK: - EXTENSION FOR ADDRESS LIST VIEW MODEL -

extension DeliveryAddressVC: AddressListViewModelDelegate{
    
    func didReceiveAddressList(response: AddressListResponse) {
        isLoading = false
        if let addressList = response.data?.addresses{
            if !addressList.isEmpty{
                self.addressList = addressList
                DispatchQueue.main.async { [weak self] in
                    self?.addressTableView.reloadData()
                }
            }else{
                self.addressTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.addressTableView.reloadData()
            }
        }
    }
    
    func didReceiveDeleteAddress(response: BaseResponse) {
        isLoading = false
    }
    
    func didReceiveResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}



//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension DeliveryAddressVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading{
            return 1
        }else{
            if addressList.count > 1{
                return 2
            }else if addressList.count == 1{
                return 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 20
        }else{
            if section == 0{
                return 1
            }else{
                return (addressList.count - 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            return configureDefaultAddressCell(at: indexPath)
        case 1:
            return configureAdditionalAddressCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading || indexPath.section == 0{
            return
        }else{
            self.currentIndex = indexPath.row
            self.addressTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: addressTableView.frame.width, height: 24.0))
        headerView.backgroundColor = R.color.newBgColor()
        let sectName = UILabel(frame: CGRect(x: 0, y: 0, width: addressTableView.frame.width - 10, height: 24.0))
        sectName.isSkeletonable = true
        sectName.numberOfLines = 1
        sectName.textAlignment = .left
        sectName.font = Fonts.mediumFontsSize14
        sectName.textColor = R.color.textBlackColor()
        
        if isLoading{
            sectName.showAnimatedGradientSkeleton()
        }else{
            sectName.hideSkeleton()
            if section == 0{
                sectName.text = PisiffikStrings.defaultAddress()
            }else{
                sectName.text = PisiffikStrings.additionalAddresses()
            }
        }
        
        headerView.addSubview(sectName)
        return headerView
    }
    
    
}

//MARK: - EXTENSION FOR ADDRESS CELL -

extension DeliveryAddressVC{
    
    private func configureDefaultAddressCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = addressTableView.dequeueReusableCell(withIdentifier: .addressCell, for: indexPath) as! AddressCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            cell.backView.backgroundColor = .white
            cell.deleteBtn.isHidden = true
            let address = addressList[indexPath.row]
            cell.typeLbl.text = address.name
            cell.addressLbl.text = address.address
            cell.backView.borderWidth = 0
            cell.editBtn.addTapGestureRecognizer { [weak self] in
                self?.navigateToEditAddressVC(mode: .home)
            }
        }
        
        return cell
    }
    
    private func configureAdditionalAddressCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = addressTableView.dequeueReusableCell(withIdentifier: .addressCell, for: indexPath) as! AddressCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            cell.backView.backgroundColor = .white
            cell.deleteBtn.isHidden = false
            
            let address = addressList[indexPath.row + 1]
            cell.typeLbl.text = address.name
            cell.addressLbl.text = address.address
            if currentIndex == indexPath.row{
                cell.backView.borderWidth = 1
                self.saveBtn.isHidden = false
            }else{
                cell.backView.borderWidth = 0
            }
            cell.backView.borderColor = R.color.lightBlueColor()
            cell.editBtn.addTapGestureRecognizer { [weak self] in
                self?.navigateToEditAddressVC(mode: .office)
            }
            cell.deleteBtn.addTapGestureRecognizer { [weak self] in
                guard let customAlertVC = R.storyboard.alertSB.customAlertVC() else {return}
                customAlertVC.delegate = self
                customAlertVC.currentIndex = (indexPath.row + 1)
                self?.present(customAlertVC, animated: true)
            }
            
        }
        
        return cell
    }
    
}

//MARK: - EXTENSION CUSTOM ALERT DELEGATES -

extension DeliveryAddressVC: CustomAlertDelegates{
    
    func didTapOnDoneBtn(at index: Int) {
        
        guard let addressID = addressList[index].id else {return}
        
        if Network.isAvailable{
            self.viewModel.deleteAddressFromListWith(id: addressID)
            self.addressList.remove(at: index)
            DispatchQueue.main.async { [weak self] in
                if self?.currentIndex == (index - 1) {
                    self?.currentIndex = -1
                    self?.saveBtn.isHidden = true
                }
                self?.addressTableView.reloadData()
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
        
    }
    
}
