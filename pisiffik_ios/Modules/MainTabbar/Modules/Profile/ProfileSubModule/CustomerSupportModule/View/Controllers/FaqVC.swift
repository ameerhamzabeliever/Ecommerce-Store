//
//  FaqVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

class FaqVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var releventLbl: UILabel!{
        didSet{
            releventLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var faqTableView: ContentSizedTableView!{
        didSet{
            faqTableView.delegate = self
            faqTableView.dataSource = self
            faqTableView.register(R.nib.faqCell)
        }
    }
    @IBOutlet weak var contactLbl: UILabel!{
        didSet{
            contactLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var clickHereBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private var faqViewModel = FaqListViewModel()
    private var faqList : [FaqList] = []
    private var isLoading : Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        faqViewModel.delegate = self
        getFaqsList()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.faq()
        releventLbl.text = PisiffikStrings.seeTheRelevantTopic()
        contactLbl.text = PisiffikStrings.contactToCustomerServiceCenter()
        clickHereBtn.titleLabel?.text = PisiffikStrings.clickHere()
        clickHereBtn.underline()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        releventLbl.font = Fonts.mediumFontsSize14
        releventLbl.textColor = R.color.textBlackColor()
        contactLbl.font = Fonts.mediumFontsSize14
        contactLbl.textColor = R.color.textBlackColor()
        clickHereBtn.titleLabel?.font = Fonts.mediumFontsSize16
        clickHereBtn.setTitleColor(R.color.textRedColor(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getFaqsList(){
        if Network.isAvailable{
            self.isLoading = true
            self.faqViewModel.getFaqList()
        }else{
            self.releventLbl.isHidden = true
            self.contactLbl.isHidden = true
            self.clickHereBtn.isHidden = true
            self.faqTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), shouldDisplay: true)
            self.faqTableView.reloadData()
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
        releventLbl.showAnimatedGradientSkeleton()
        contactLbl.showAnimatedGradientSkeleton()
        clickHereBtn.isHidden = true
    }
    
    private func hideSkeletonView(){
        releventLbl.hideSkeleton()
        contactLbl.hideSkeleton()
        clickHereBtn.isHidden = false
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
    
    @IBAction func didTapClickHereBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let contactHelpVC = R.storyboard.contactServiceSB.contactHelpVC() else {return}
            self.push(controller: contactHelpVC, hideBar: true, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR FAQ LIST VIEW MODEL DELEGATES -

extension FaqVC: FaqListViewModelDelegate{
    
    func didReceiveFaqList(response: FaqListResponse) {
        self.isLoading = false
        if let data = response.data?.faqList{
            self.faqList = data
            DispatchQueue.main.async { [weak self] in
                self?.faqTableView.reloadData()
            }
        }
    }
    
    func didReceiveFaqListResponseWithWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.faqTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.faqTableView.reloadData()
        self.faqTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.faqViewModel.getFaqList()
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension FaqVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : self.faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureFaqCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading {return}
        guard let faqDetailVC = R.storyboard.contactServiceSB.faqDetailVC() else {return}
        faqDetailVC.currentTitle = self.faqList[indexPath.row].name ?? ""
        faqDetailVC.currentID = self.faqList[indexPath.row].id ?? 0
        self.push(controller: faqDetailVC, hideBar: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading{
            return 60.0
        }else{
            return UITableView.automaticDimension
        }
    }
    
}

//MARK: - EXTENSION FOR FAQ CELL -

extension FaqVC{
    
    private func configureFaqCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = faqTableView.dequeueReusableCell(withIdentifier: .faqCell, for: indexPath) as! FaqCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            let faq = faqList[indexPath.row]
            cell.nameLbl.text = faq.name
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(faq.icon ?? "")"){
                cell.leadingImage.kf.indicatorType = .activity
                cell.leadingImage.kf.setImage(with: imageURL)
            }
            cell.trailingImage.image = R.image.ic_forward_icon()
        }
        
        return cell
    }
    
}
