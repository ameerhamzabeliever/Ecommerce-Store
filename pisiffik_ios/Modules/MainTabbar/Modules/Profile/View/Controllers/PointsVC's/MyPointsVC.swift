//
//  MyPointsVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

struct PointsModel{
    let type: String
    let points: String
    let orderNo: String
    let date: String
}

class MyPointsVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var pointsTypeLbl: UILabel!
    @IBOutlet weak var pointsDurationLbl: UILabel!
    @IBOutlet weak var pointsTableView: UITableView!{
        didSet{
            pointsTableView.delegate = self
            pointsTableView.dataSource = self
            pointsTableView.register(R.nib.myPointsCell)
            pointsTableView.sectionHeaderHeight = UITableView.automaticDimension
            pointsTableView.estimatedSectionHeaderHeight = 10.0
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var myPointsVM = MyPointsViewModel()
    private var isLoading: Bool = false
    private var currentPoints: Int{
        return UserDefault.shared.getUserCurrentPoints()
    }
    private var arrayOfPoints: [MyPoints] = []
    private var currentPage: Int = 0
    private var totalPage: Int = 1
    private var pointsType: MyPointsEarnedType = .redeem
    private var pointsSort: MyPointsDurationType = .week
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        myPointsVM.delegate = self
        self.getPoints(of: self.pointsType, sort: self.pointsSort)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.points()
        pointsLbl.text = currentPoints > Constants.maxLoyalityPoints ? "\(Constants.maxLoyalityPoints)+" : "\(currentPoints)"
        pointsTypeLbl.text = self.pointsType.rawValue
        pointsDurationLbl.text = self.pointsSort.rawValue
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        pointsLbl.font = Fonts.boldFontsSize27
        pointsLbl.textColor = R.color.textWhiteColor()
        pointsTypeLbl.font = Fonts.mediumFontsSize14
        pointsTypeLbl.textColor = R.color.textBlackColor()
        pointsDurationLbl.font = Fonts.mediumFontsSize14
        pointsDurationLbl.textColor = R.color.textBlackColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getPoints(of type: MyPointsEarnedType,sort: MyPointsDurationType){
        if Network.isAvailable{
            self.currentPage += 1
            self.isLoading = true
            self.pointsTableView.reloadData()
            let request = MyPointsRequest(type: type.rawValue.capitalized, sort: sort.rawValue.capitalized, limit: 10)
            self.myPointsVM.getMyPoints(with: request, currentPage: self.currentPage)
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
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapSowFilterBtn(_ sender: UIButton){
        switch sender.tag{
        case 0:
            self.searchFilterByPointsType()
        case 1:
            self.searchFilterByPointsDuration()
        default:
            Constants.printLogs("........")
        }
    }
    
}

//MARK: - EXTENSION FOR MyPointsViewModel DELEGATES -

extension MyPointsVC: MyPointsViewModelDelegate{
    
    func didReceiveMyPoints(response: MyPointsResponse) {
        isLoading = false
        if let currentPage = response.data?.currentPage,
           let totalPage = response.data?.total,
           let myPoints = response.data?.list{
            self.currentPage = currentPage
            self.totalPage = totalPage
            if !myPoints.isEmpty{
                myPoints.forEach { point in
                    self.arrayOfPoints.append(point)
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.pointsTableView.reloadData()
        }
           
    }
    
    func didReceiveMyPointsResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.pointsTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METODS -

extension MyPointsVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : arrayOfPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureMyPoints(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storePurchaseVC = R.storyboard.purchaseSB.storePurchaseVC() else {return}
        storePurchaseVC.type = MyPointsEarnedType(rawValue: self.arrayOfPoints[indexPath.row].type ?? "") ?? .redeem
        storePurchaseVC.pointsID = self.arrayOfPoints[indexPath.row].id ?? 0
        storePurchaseVC.mode = .points
        self.push(controller: storePurchaseVC, hideBar: true, animated: true)
//        guard let onlineOrderVC = R.storyboard.purchaseSB.onlinePurchaseVC() else {return}
//        self.push(controller: onlineOrderVC, hideBar: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoading {return}
        if ((self.currentPage < self.totalPage) && (indexPath.row == (self.arrayOfPoints.count - 1))){
            self.getPoints(of: self.pointsType, sort: self.pointsSort)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MyPointsHeaderView.fromNib()
        
        return headerView
    }

    
}

//MARK: - EXTENSION FOR POINTS CELL -

extension MyPointsVC{
    
    private func configureMyPoints(at indexPath: IndexPath) -> UITableViewCell{
        let cell = pointsTableView.dequeueReusableCell(withIdentifier: .myPointsCell, for: indexPath) as! MyPointsCell
        
        if isLoading{
            cell.showSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let point = arrayOfPoints[indexPath.row]
            cell.typeLbl.text = point.type ?? ""
            cell.pointsLbl.text = "\(point.points ?? 0)"
            cell.orderOnLbl.text = "\(point.orderNo ?? 0)"
            cell.dateLbl.text = point.date
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR SHOW FILTER VC -

extension MyPointsVC{
    
    fileprivate func searchFilterByPointsType(){
        guard let filterVC = R.storyboard.profileSB.myPointsFilterVC() else {return}
        filterVC.mode = .filterByPointsType
        filterVC.delegate = self
        self.present(filterVC, animated: true)
    }
    
    fileprivate func searchFilterByPointsDuration(){
        guard let filterVC = R.storyboard.profileSB.myPointsFilterVC() else {return}
        filterVC.mode = .filterByPointsDuration
        filterVC.delegate = self
        self.present(filterVC, animated: true)
    }
    
}


//MARK: - EXTENSION FOR SHOW FILTER DELEGATES -

extension MyPointsVC: MyPointsFilterProtocol{
    
    func didSelectCurrentPoints(type: String, of filterType: MyPointsFilterMode) {
        switch filterType {
        case .filterByPointsType:
            self.pointsTypeLbl.text = type
            self.pointsType = MyPointsEarnedType(rawValue: type) ?? .redeem
            self.arrayOfPoints.removeAll()
            self.currentPage = 0
            self.getPoints(of: self.pointsType, sort: self.pointsSort)
        case .filterByPointsDuration:
            self.pointsDurationLbl.text = type
            self.pointsSort = MyPointsDurationType(rawValue: type) ?? .week
            self.arrayOfPoints.removeAll()
            self.currentPage = 0
            self.getPoints(of: self.pointsType, sort: self.pointsSort)
        }
    }
    
}
