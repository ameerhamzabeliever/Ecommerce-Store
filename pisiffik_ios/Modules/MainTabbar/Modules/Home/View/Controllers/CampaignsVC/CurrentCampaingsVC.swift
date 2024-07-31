//
//  CurrentCampaingsVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class CurrentCampaingsVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var campaingTableView: UITableView!{
        didSet{
            campaingTableView.delegate = self
            campaingTableView.dataSource = self
            campaingTableView.register(R.nib.campaignsCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private let allCampaignsVM = AllCampaignsViewModel()
    private var arrayOfCampaigns: [HomeCampaignData] = []
    private var mediaURL: String = UserDefault.shared.getMediaURL()
    private var isLoading: Bool = false
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        allCampaignsVM.delegate = self
        getAllCampaigns()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.currentCampaigns()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getAllCampaigns(){
        if !Network.isAvailable{
            self.campaingTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.allCampaignsVM.getAllCampaigns()
            }
        }else{
            self.isLoading = true
            self.allCampaignsVM.getAllCampaigns()
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR ALL CAMPAIGNS VIEW MODEL DELEGATES -

extension CurrentCampaingsVC: AllCampaignsViewModelDelegate{
    
    func didReceiveAllCampaigns(response: AllCampaignsResponse) {
        self.isLoading = false
        self.arrayOfCampaigns.removeAll()
        if let campaigns = response.data?.campaign,
           !campaigns.isEmpty{
            self.arrayOfCampaigns = campaigns
        }
        self.mediaURL = response.data?.media_url ?? UserDefault.shared.getMediaURL()
        DispatchQueue.main.async { [weak self] in
            self?.campaingTableView.reloadData()
        }
    }
    
    func didReceiveAllCampaignsResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.campaingTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.campaingTableView.reloadData()
            self.campaingTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.allCampaignsVM.getAllCampaigns()
            }
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension CurrentCampaingsVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : self.arrayOfCampaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCampaignCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let campaignDetailVC = R.storyboard.homeSB.campaignDetailVC() else {return}
        campaignDetailVC.campaignData = self.arrayOfCampaigns[indexPath.row]
        self.push(controller: campaignDetailVC, hideBar: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .pad{
            //690.0
            return 850.0
        }else{
            //260.0
            return 320.0
        }
    }
    
}

//MARK: - EXTENSION FOR CAMPAIGN CELL -

extension CurrentCampaingsVC{
    
    private func configureCampaignCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = campaingTableView.dequeueReusableCell(withIdentifier: .campaignsCell, for: indexPath) as! CampaignsCell
        
        if isLoading{
            cell.showSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let campaign = self.arrayOfCampaigns[indexPath.row]
            
            if let imageURL = URL(string: "\(self.mediaURL)\(campaign.banner ?? "")"){
                cell.campaignImageView.kf.indicatorType = .activity
                cell.campaignImageView.kf.setImage(with: imageURL)
            }
        }
        
        return cell
    }
}
