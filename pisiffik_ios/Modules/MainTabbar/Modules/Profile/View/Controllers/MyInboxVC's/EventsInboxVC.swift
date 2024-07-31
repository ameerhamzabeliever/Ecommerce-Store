//
//  EventsInboxVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher

class EventsInboxVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var eventTableView: UITableView!{
        didSet{
            eventTableView.delegate = self
            eventTableView.dataSource = self
            eventTableView.register(R.nib.eventsCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var viewModel = EventsListViewModel()
    private var isLoading : Bool = false
    private var arrayOfEvents : [EventsList] = []
    private var currentPage : Int = 0
    private var eventsCurrentPage : Int = 0
    private var eventsLastPage : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getEventsList()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getEventsList(){
        if !Network.isAvailable{
            self.eventTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.currentPage += 1
                if self.currentPage == 1{
                    self.isLoading = true
                }else{
                    self.isLoading = false
                }
                self.viewModel.getInboxEventsList(currentPage: self.currentPage)
            }
        }else{
            self.currentPage += 1
            if currentPage == 1{
                self.isLoading = true
            }else{
                self.isLoading = false
            }
            self.viewModel.getInboxEventsList(currentPage: self.currentPage)
        }
    }
    
    
    private func navigateToEventDetailVC(at indexPath: IndexPath){
        let event = self.arrayOfEvents[indexPath.row]
        guard let eventID = event.id else {return}
        self.arrayOfEvents[indexPath.row].isRead = 0
        self.eventTableView.reloadData()
        EventIDLocalManager.shared.saveEventID(id: eventID)
        let currentEvent = EventsList(id: event.id, name: event.name, description: event.description, image: event.image, date: event.date, isRead: event.isRead)
        guard let eventDetailVC = R.storyboard.profileSB.eventDetailVC() else {return}
        eventDetailVC.eventID = eventID
        eventDetailVC.event = currentEvent
        self.push(controller: eventDetailVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    
    
}

//MARK: - EXTENSION FOR EVENT LIST VIEW MOIDEL DELEGATES -

extension EventsInboxVC: EventsListViewModelDelegate{
    
    func didReceiveEventsList(response: EventsListResponse) {
        isLoading = false
        self.eventsCurrentPage = response.data?.currentPage ?? 0
        self.eventsLastPage = response.data?.lastPage ?? 0
        let eventIDs = EventIDLocalManager.shared.getEventID()
        if let list = response.data?.events{
            if !list.isEmpty{
                for item in list{
                    var event : EventsList = item
                    if !eventIDs.isEmpty{
                        if eventIDs.contains(where: {$0 == event.id}){
                            event.isRead = 0
                        }else{
                            event.isRead = 1
                        }
                    }else{
                        event.isRead = 1
                    }
                    self.arrayOfEvents.append(event)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.eventTableView.reloadData()
                }
            }else{
                self.currentPage -= 1
                if self.arrayOfEvents.isEmpty{
                    self.eventTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    self.eventTableView.reloadData()
                }else{
                    return
                }
            }
        }
    }
    
    func didReceiveEventsListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.eventTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.eventTableView.reloadData()
        self.eventTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.viewModel.getInboxEventsList(currentPage: self.currentPage)
        }
    }
    
}


//MARK: - EXTENSION FOR NEWS LIST VIEW METHODS -

extension EventsInboxVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : self.arrayOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureEventsCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        if LocationManager.shared.userDeniedLocation{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDistanceAlertMessage(),cancelBtnHide: false, delegate: self)
        }else{
            self.navigateToEventDetailVC(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.arrayOfEvents.count - 1) && self.eventsCurrentPage != self.eventsLastPage && self.eventsCurrentPage < self.eventsLastPage{
            getEventsList()
        }
    }
    
}

//MARK: - EXTENSION FOR NEWS CELL -

extension EventsInboxVC{
    
    private func configureEventsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = eventTableView.dequeueReusableCell(withIdentifier: .eventsCell, for: indexPath) as! EventsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            
            cell.hideSkeletonView()
            
            let event = arrayOfEvents[indexPath.row]
            cell.headingLbl.text = event.name
            cell.descriptionLbl.text = event.description
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(event.image ?? "")"){
                cell.eventsImage.kf.indicatorType = .activity
                cell.eventsImage.kf.setImage(with: imageURL)
            }
            cell.dateLbl.text = event.date
            if event.isRead == 0{
                cell.notificationReadImage.isHidden = true
            }else{
                cell.notificationReadImage.isHidden = false
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR STORE HELP DELEGATE VC -

extension EventsInboxVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}
