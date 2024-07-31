//
//  ContactUsVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class ContactUsVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var contactUsLbl: UILabel!{
        didSet{
            contactUsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var phoneNmbLbl: UILabel!{
        didSet{
            phoneNmbLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var hoursTableView: ContentSizedTableView!{
        didSet{
            hoursTableView.delegate = self
            hoursTableView.dataSource = self
            hoursTableView.register(R.nib.productStoreTimingCell)
        }
    }
    @IBOutlet weak var moreInfoLbl: UILabel!{
        didSet{
            moreInfoLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeFaqBtn: UIButton!
    @IBOutlet weak var hoursBackView: UIView!{
        didSet{
            hoursBackView.isSkeletonable = true
        }
    }
    @IBOutlet weak var phoneNmbBtn: UIButton!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var viewModel = CustomerServiceViewModel()
    private var isLoading: Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    private var arrayOfHours : [PisiffikItemDetailStoresTimings] = []
    private var contactNmb : String = ""
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getCustomerServiceDetail()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.customerService()
        phoneNmbLbl.text = self.contactNmb
        contactUsLbl.text = PisiffikStrings.youCanContactUs()
        moreInfoLbl.text = PisiffikStrings.forMoreInformation()
        seeFaqBtn.titleLabel?.text = PisiffikStrings.seeFAQ()
        seeFaqBtn.underline()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        contactUsLbl.font = Fonts.mediumFontsSize16
        contactUsLbl.textColor = R.color.textBlackColor()
        phoneNmbLbl.font = Fonts.mediumFontsSize12
        phoneNmbLbl.textColor = R.color.textBlueColor()
        moreInfoLbl.font = Fonts.mediumFontsSize14
        moreInfoLbl.textColor = R.color.textBlackColor()
        seeFaqBtn.titleLabel?.font = Fonts.mediumFontsSize16
        seeFaqBtn.setTitleColor(R.color.textRedColor(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getCustomerServiceDetail(){
        if Network.isAvailable{
            isLoading = true
            self.viewModel.getCustomerServiceDetails()
        }else{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.oopsNoInternetConnection(), delegate: self)
        }
    }
    
    private func configureSkeletonView(){
        if isLoading{
            self.setSkeletonView()
        }else{
            self.hideSkeletonView()
        }
    }
    
    private func setSkeletonView(){
        backView.showAnimatedGradientSkeleton()
        contactUsLbl.showAnimatedGradientSkeleton()
        phoneNmbLbl.isHidden = true
        moreInfoLbl.showAnimatedGradientSkeleton()
        hoursBackView.showAnimatedGradientSkeleton()
        phoneNmbBtn.isHidden = true
        seeFaqBtn.isHidden = true
    }
    
    private func hideSkeletonView(){
        backView.hideSkeleton()
        contactUsLbl.hideSkeleton()
        phoneNmbLbl.isHidden = false
        moreInfoLbl.hideSkeleton()
        hoursBackView.hideSkeleton()
        phoneNmbBtn.isHidden = false
        seeFaqBtn.isHidden = false
    }
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapSeeFaqsBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let faqVC = R.storyboard.contactServiceSB.faqVC() else {return}
            self.push(controller: faqVC, hideBar: true, animated: true)
        }
    }
    
    
}

//MARK: - EXTENSION FOR CUSTOMER SERVICE VIEW MODEL DELEGATES -

extension ContactUsVC: CustomerServiceViewModelDelegate{
    
    func didReceiveCustomerService(response: CustomerServiceResponse) {
        self.isLoading = false
        if let data = response.data?.customerService{
            if let contactNmb = data.number,
               let hours = data.timings{
                self.contactNmb = contactNmb
                self.phoneNmbLbl.text = contactNmb
                self.arrayOfHours = hours
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.hoursTableView.reloadData()
        }
    }
    
    func didReceiveCustomerServiceResponseWithWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
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

extension ContactUsVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 15 : self.arrayOfHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureStoreTimingCell(at: indexPath)
    }
    
}

//MARK: - EXTENSION FOR HOUR CELL -

extension ContactUsVC{
    
    private func configureStoreTimingCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = hoursTableView.dequeueReusableCell(withIdentifier: .productStoreTimingCell, for: indexPath) as! ProductStoreTimingCell
        
        if isLoading{
            cell.isLoading = true
            
        }else{
            cell.isLoading = false
            
            cell.daysLbl.text = self.arrayOfHours[indexPath.row].day
            cell.timeLbl.text = "\(self.arrayOfHours[indexPath.row].from ?? "") - \(self.arrayOfHours[indexPath.row].to ?? "")"
            
        }
        return cell
    }
    
}

//MARK: - EXTENSION FOR STORE ALERT VC DELEGATES -

extension ContactUsVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
