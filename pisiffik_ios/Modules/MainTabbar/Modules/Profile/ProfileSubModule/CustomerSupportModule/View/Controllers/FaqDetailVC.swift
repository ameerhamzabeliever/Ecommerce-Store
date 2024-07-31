//
//  FaqDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

struct FaqDetailModel{
    
    var id : Int?
    var question: String?
    var answer : String?
    var isOpened : Bool
    
}

class FaqDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var faqTableView: UITableView!{
        didSet{
            faqTableView.delegate = self
            faqTableView.dataSource = self
            faqTableView.register(R.nib.faqDetailCell)
            faqTableView.estimatedRowHeight = 60.0
            faqTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contactLbl: UILabel!{
        didSet{
            contactLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var clickHereBtn: UIButton!
    @IBOutlet weak var searchBarBackView: UIView!
    
    //MARK: - PROPERTIES -
    
    private var faqsViewModel = FaqDetailListViewModel()
    private var arrayOfFaqs: [FaqDetailModel] = [FaqDetailModel]()
    private var isLoading: Bool = false{
        didSet{
            self.configureSkeletonView()
        }
    }
    private var searchingList: [FaqDetailModel] = [FaqDetailModel]()
    private var isSearching : Bool = false
    var currentTitle : String = ""
    var currentID : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        faqsViewModel.delegate = self
        getFaqs()
        searchTextField.addTarget(self, action: #selector(didSearchingFaqList(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = currentTitle
        searchTextField.placeholder = PisiffikStrings.search()
        contactLbl.text = PisiffikStrings.contactToCustomerServiceCenter()
        clickHereBtn.titleLabel?.text = PisiffikStrings.clickHere()
        clickHereBtn.underline()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        searchTextField.font = Fonts.mediumFontsSize14
        contactLbl.font = Fonts.mediumFontsSize14
        contactLbl.textColor = R.color.textBlackColor()
        clickHereBtn.titleLabel?.font = Fonts.mediumFontsSize16
        clickHereBtn.setTitleColor(R.color.textRedColor(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getFaqs(){
        searchBarBackView.isHidden = true
        if Network.isAvailable{
            isLoading = true
            self.faqsViewModel.getFaqsBy(id: self.currentID)
        }else{
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
        contactLbl.showAnimatedGradientSkeleton()
        clickHereBtn.isHidden = true
    }
    
    private func hideSkeletonView(){
        contactLbl.hideSkeleton()
        clickHereBtn.isHidden = false
    }
    
    
    //MARK: - ACTIONS -
    
    @objc func didSearchingFaqList(_ textField: UITextField){
        if let text = textField.text{
            if text.isEmpty{
                isSearching = false
                searchTextField.text = ""
                self.faqTableView.reloadData()
            }else{
                searchingList = arrayOfFaqs.filter({$0.question?.localizedCaseInsensitiveContains(text) ?? false})
                isSearching = true
                self.faqTableView.reloadData()
            }
        }else{
            isSearching = false
            searchTextField.text = ""
            self.faqTableView.reloadData()
        }
    }
    
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

//MARK: - EXTENSION FOR FAQS VIEW MODEL DELEGATES -

extension FaqDetailVC: FaqDetailListViewModelDelegate{
    
    func didReceiveFaqs(response: FaqDetailListResponse) {
        self.isLoading = false
        if let list = response.data?.faqs{
            if !list.isEmpty{
                for item in list{
                    let faq = FaqDetailModel(id: item.id, question: item.question, answer: item.answer, isOpened: false)
                    self.arrayOfFaqs.append(faq)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.searchBarBackView.isHidden = false
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.faqTableView.reloadData()
        }
    }
    
    func didReceiveFaqResponseWithWith(errorMessage: [String]?,statusCode: Int?) {
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
            self.faqsViewModel.getFaqsBy(id: self.currentID)
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension FaqDetailVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 10 : isSearching ? searchingList.count : arrayOfFaqs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1
        }else if isSearching{
            if searchingList[section].isOpened {
                return 2
            }else{
                return 1
            }
        }else{
            if arrayOfFaqs[section].isOpened {
                return 2
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            return configureSearchingFaqCell(at: indexPath)
        }else{
            return configureFaqCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading {return}
        if isSearching{
            if indexPath.row == 0{
                searchingList[indexPath.section].isOpened = !searchingList[indexPath.section].isOpened
                if let index = self.arrayOfFaqs.firstIndex(where: {$0.id == searchingList[indexPath.section].id}){
                    self.arrayOfFaqs[index].isOpened = !self.arrayOfFaqs[index].isOpened
                }
                self.faqTableView.reloadSections([indexPath.section], with: .none)
            }else{
                Constants.printLogs("....")
            }
        }else{
            if indexPath.row == 0{
                arrayOfFaqs[indexPath.section].isOpened = !arrayOfFaqs[indexPath.section].isOpened
                self.faqTableView.reloadSections([indexPath.section], with: .none)
            }else{
                Constants.printLogs("****")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading {
            return 45.0
        }else{
            return UITableView.automaticDimension
        }
    }
    
}

//MARK: - EXTENSION FOR FAQ CELL -

extension FaqDetailVC{
    
    private func configureFaqCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = faqTableView.dequeueReusableCell(withIdentifier: .faqDetailCell, for: indexPath) as! FaqDetailCell
      
        if isLoading{
            cell.setSkeletonView()
            self.faqTableView.separatorStyle = .none
            
        }else{
            cell.hideSkeletonView()
            self.faqTableView.separatorStyle = .singleLine
            
            if indexPath.row == 0{
                cell.faqTxtLbl.text = arrayOfFaqs[indexPath.section].question
                cell.faqTxtLbl.font = Fonts.mediumFontsSize14
                cell.faqTxtLbl.textColor = R.color.textBlackColor()
                cell.checkImage.isHidden = false
            }else{
                cell.faqTxtLbl.text = arrayOfFaqs[indexPath.section].answer
                cell.faqTxtLbl.font = Fonts.regularFontsSize12
                cell.faqTxtLbl.textColor = R.color.textGrayColor()
                cell.checkImage.isHidden = true
                
            }
            
            if arrayOfFaqs[indexPath.section].isOpened{
                cell.checkImage.image = R.image.ic_faq_upward_arrow()
            }else{
                cell.checkImage.image = R.image.ic_faq_downward_arrow()
            }
            
        }
        
        return cell
    }
    
    
    private func configureSearchingFaqCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = faqTableView.dequeueReusableCell(withIdentifier: .faqDetailCell, for: indexPath) as! FaqDetailCell
        
        if isLoading{
            cell.setSkeletonView()
            self.faqTableView.separatorStyle = .none
            
        }else{
            cell.hideSkeletonView()
            self.faqTableView.separatorStyle = .singleLine
            
            if indexPath.row == 0{
                cell.faqTxtLbl.text = searchingList[indexPath.section].question
                cell.faqTxtLbl.font = Fonts.mediumFontsSize14
                cell.faqTxtLbl.textColor = R.color.textBlackColor()
                cell.checkImage.isHidden = false
            }else{
                cell.faqTxtLbl.text = searchingList[indexPath.section].answer
                cell.faqTxtLbl.font = Fonts.regularFontsSize12
                cell.faqTxtLbl.textColor = R.color.textGrayColor()
                cell.checkImage.isHidden = true
                
            }
            
            if searchingList[indexPath.section].isOpened{
                cell.checkImage.image = R.image.ic_faq_upward_arrow()
            }else{
                cell.checkImage.image = R.image.ic_faq_downward_arrow()
            }
            
        }
        
        return cell
    }
    
    
}
