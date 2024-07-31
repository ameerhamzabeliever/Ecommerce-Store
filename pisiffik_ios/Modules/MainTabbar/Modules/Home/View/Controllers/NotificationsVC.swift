//
//  NotificationsVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!{
        didSet{
            notificationTableView.delegate = self
            notificationTableView.dataSource = self
            notificationTableView.register(R.nib.newsCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var viewModel : NotificationViewModel = NotificationViewModel()
    private var isLoading : Bool = false
    private var arrayOfNotifications: [NotificationList] = []
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getNotificationsList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.notifications()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getNotificationsList(){
        if !Network.isAvailable{
            self.notificationTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.viewModel.getNotificationList()
            }
        }else{
            self.isLoading = true
            self.viewModel.getNotificationList()
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR HOME VIEW MODEL DELEGATES -

extension NotificationsVC: NotificationViewModelDelegate {
    
    func didReceiveNotification(response: NotificationListResponse) {
        self.isLoading = false
        if let notifications = response.data?.notifications{
            if !notifications.isEmpty{
                let arrayOfId = UserDefault.shared.getNotificationsID()
                for index in (0...(notifications.count - 1)) {
                    if arrayOfId.contains(where: {$0 == notifications[index].id}){
                        let notificationObj = getNotificationObjWith(notificationObj: notifications[index], isRead: 1)
                        self.arrayOfNotifications.append(notificationObj)
                    }else{
                        let notificationObj = getNotificationObjWith(notificationObj: notifications[index], isRead: 0)
                        self.arrayOfNotifications.append(notificationObj)
                    }
                }
            }else{
                self.notificationTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.notificationTableView.reloadData()
        }
    }
    
    func didReceiveNotificationResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.notificationTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.notificationTableView.reloadData()
        self.notificationTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.viewModel.getNotificationList()
        }
    }
    
}


//MARK: - EXTENSION FOR NEWS LIST VIEW METHODS -

extension NotificationsVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 15 : arrayOfNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureNotificationsCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading {return}
        if Network.isAvailable{
            self.notificationMarkAsRead(at: indexPath.row)
            if let type = self.arrayOfNotifications[indexPath.row].event{
                self.didTapOnNotificationOf(type: type, at: indexPath.row)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
}

//MARK: - EXTENSION FOR NEWS CELL -

extension NotificationsVC{
    
    private func configureNotificationsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: .newsCell, for: indexPath) as! NewsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            let notification = arrayOfNotifications[indexPath.row]
            cell.notificationImage.image = R.image.ic_notification_icon()
            cell.headingLbl.text = notification.title
            cell.descriptionLbl.text = notification.body
            cell.dateLbl.text = notification.createdAt
            cell.descriptionLbl.numberOfLines = 2
            
            if notification.isRead == 0{
                cell.notificationReadImage.isHidden = false
            }else{
                cell.notificationReadImage.isHidden = true
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR DID TAP NOTIFICATION -

extension NotificationsVC{
    
    private func didTapOnNotificationOf(type: String,at index: Int){
        if type == NotificationTypes.news{
            navigateToNewsDetailVC(at: index)
        }else if type == NotificationTypes.event{
            if LocationManager.shared.userDeniedLocation{
                self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDistanceAlertMessage(),cancelBtnHide: false, delegate: self)
            }else{
                navigateToEventDetailVC(at: index)
            }
        }else if type == NotificationTypes.recipe{
            navigateToRecipeDetailVC(at: index)
        }else if type == NotificationTypes.message{
            navigateToTicketDetailVC(at: index)
        }else if type == NotificationTypes.general{
            showGeneralInfo(at: index)
        }else{
            Constants.printLogs("***********")
        }
    }
    
    private func notificationMarkAsRead(at index: Int){
        if arrayOfNotifications[index].event == NotificationTypes.event && LocationManager.shared.userDeniedLocation{
            return
        }
        if let id = arrayOfNotifications[index].id{
            if arrayOfNotifications[index].isRead == 0{
                UserDefault.shared.saveNotificationsID(id: id)
                self.arrayOfNotifications[index].isRead = 1
                let badge = (UserDefault.shared.getNotificationBadgeCount() - 1)
                UserDefault.shared.saveNotificationBadge(count: badge)
                DispatchQueue.main.async { [weak self] in
                    self?.notificationTableView.reloadData()
                }
            }
        }
    }
    
    private func getNotificationObjWith(notificationObj: NotificationList,isRead: Int) -> NotificationList{
        var notification = NotificationList()
        notification.id = notificationObj.id
        notification.title = notificationObj.title
        notification.body = notificationObj.body
        notification.event = notificationObj.event
        notification.createdAt = notificationObj.createdAt
        notification.isRead = isRead
        notification.data = notificationObj.data
        return notification
    }
    
}

//MARK: - EXTENSION FOR REDIRECTION -

extension NotificationsVC{
    
    private func navigateToNewsDetailVC(at index: Int){
        
        if let jsonStr = arrayOfNotifications[index].data{
            if let news = convertJsonStringToModel(jsonStr: jsonStr, type: NewsList.self){
                NewsLocalManager.shared.saveNewsID(id: news.id ?? 0)
                guard let newsDetailVC = R.storyboard.profileSB.newsDetailVC() else {return}
                newsDetailVC.newsObj = news
                self.push(controller: newsDetailVC, hideBar: true, animated: true)
            }
        }
        
    }
    
    private func navigateToEventDetailVC(at index: Int){
        
        if let jsonStr = arrayOfNotifications[index].data{
            if let event = convertJsonStringToModel(jsonStr: jsonStr, type: EventsList.self){
                EventIDLocalManager.shared.saveEventID(id: event.id ?? 0)
                guard let eventDetailVC = R.storyboard.profileSB.eventDetailVC() else {return}
                eventDetailVC.eventID = event.id ?? 0
                eventDetailVC.event = event
                self.push(controller: eventDetailVC, hideBar: true, animated: true)
            }
        }

    }
    
    private func navigateToRecipeDetailVC(at index: Int){
        if let jsonStr = arrayOfNotifications[index].data{
            if let recipe = convertJsonStringToModel(jsonStr: jsonStr, type: RecipeNotificationData.self){
                guard let recipeDetailVC = R.storyboard.homeSB.recipesDetailVC() else {return}
                recipeDetailVC.currentTitle = recipe.recipeType ?? PisiffikStrings.recipes()
                recipeDetailVC.currentID = recipe.id ?? 0
                recipeDetailVC.mode = .byNotifications
                self.push(controller: recipeDetailVC, hideBar: true, animated: true)
            }
        }
    }
    
    private func navigateToTicketDetailVC(at index: Int){
        if let jsonStr = arrayOfNotifications[index].data{
            if let ticket = convertJsonStringToModel(jsonStr: jsonStr, type: TicketList.self){
                if ticket.status != 3{
                    guard let ticketDetailVC = R.storyboard.profileSB.ticketDetailVC() else {return}
                    ticketDetailVC.currentTicket = ticket
                    self.push(controller: ticketDetailVC, hideBar: true, animated: true)
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.ticketClosedError()])
                }
            }
        }
    }
    
    private func showGeneralInfo(at index: Int){
        let notification = self.arrayOfNotifications[index]
        self.showAlert(title: notification.title ?? "", errorMessages: [notification.body ?? ""])
    }
    
    private func convertJsonStringToModel<T: Decodable>(jsonStr: String,type: T.Type) -> T?{
        let jsonData = Data(jsonStr.utf8)
        let decoder = JSONDecoder()
        do{
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
        }catch{
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}



//MARK: - EXTENSION FOR STORE HELP DELEGATE VC -

extension NotificationsVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}


//MARK: - NOTIFICATION TYPES -

struct NotificationTypes{
    
    private init(){}
    
    static var news : String {
        return "NEWS"
    }
    
    static var event : String{
        return "EVENT"
    }
    
    static var general : String {
        return "GENERAL"
    }
    
    static var recipe : String {
        return "RECIPE"
    }
    
    static var message : String {
        return "MESSAGE"
    }
    
}


struct RecipeNotificationData: Codable {
    
    var id: Int?
    var recipeType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case recipeType = "recipe_type"
    }
}
