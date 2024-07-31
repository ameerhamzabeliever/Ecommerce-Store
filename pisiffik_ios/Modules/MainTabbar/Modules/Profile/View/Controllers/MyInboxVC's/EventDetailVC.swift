//
//  EventDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import EventKit

class EventDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var eventTableView: ContentSizedTableView!{
        didSet{
            eventTableView.delegate = self
            eventTableView.dataSource = self
            eventTableView.register(R.nib.eventDetailCell)
            eventTableView.register(R.nib.eventDetailHeaderCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    var eventID : Int = -1
    private var viewModel = EventDetailViewModel()
    private var isLoading : Bool = false
    var event : EventsList = EventsList()
    private var stores : [EventDetailStores] = []
    
    private var eventIdentifier : String = ""
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.viewModel.delegate = self
        getEventDetail()
//        checkUserLocationPermission()
        Constants.printLogs("Date: \(Date())")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefault.shared.saveEventDetailVC(open: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefault.shared.saveEventDetailVC(open: false)
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = self.event.name
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func checkUserLocationPermission(){
        if LocationManager.shared.userDeniedLocation{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDistanceAlertMessage(), delegate: self)
        }
    }
    
    private func getEventDetail(){
        isLoading = true
        let request = EventDetailRequest(id: self.eventID,latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
        self.viewModel.getInboxEventDetail(with: request)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapDirectionBtn(_ sender: UIButton){
        sender.showAnimation {
            if Network.isAvailable{
                if !LocationManager.shared.userDeniedLocation{
                    
                    if let latitude = self.stores[sender.tag - 1].latitude,
                       let longitude = self.stores[sender.tag - 1].longitude,
                       let destinationLat = Double(latitude),
                       let destinationLng = Double(longitude),
                       let currentLat = Double(LocationManager.shared.lat),
                       let currentLng = Double(LocationManager.shared.long){
                        
                        guard let directionVC = R.storyboard.profileSB.directionVC() else {return}
                        directionVC.currentLat = currentLat
                        directionVC.currentLng = currentLng
                        directionVC.destinationLat = destinationLat
                        directionVC.destinationLng = destinationLng
                        directionVC.destinationName = self.stores[sender.tag - 1].name ?? ""
                        self.push(controller: directionVC, hideBar: true, animated: true)
                        
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsStoreDirectionNotAvailable()])
                    }
                    
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), delegate: self)
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    
}

//MARK: - EXTENSION FOR EVENT DETAIL VIEW MODEL DELEGATES -

extension EventDetailVC: EventDetailViewModelDelegate{
    
    func didReceiveEventDetail(response: EventDetailResponse) {
        isLoading = false
        if let stores = response.data?.stores{
//            self.stores = stores
            self.updateStoresList(stores: stores)
        }
        DispatchQueue.main.async { [weak self] in
            self?.eventTableView.reloadData()
        }
    }
    
    func didReceiveEventDetailResponseWith(errorMessage: [String]?, statusCode: Int?) {
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
        if type == APIType.homeAPI{
            self.eventTableView.reloadData()
            self.eventTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                let request = EventDetailRequest(id: self.eventID, latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
                self.viewModel.getInboxEventDetail(with: request)
            }
        }
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension EventDetailVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : (self.stores.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return configureEventDetailHeaderCell(at: indexPath)
        }else{
            return configureEventDetailCell(at: indexPath)
        }
        
    }
    
}

//MARK: - EXTENSION FOR EVENT DETAIL CELL -

extension EventDetailVC{
    
    private func configureEventDetailHeaderCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = eventTableView.dequeueReusableCell(withIdentifier: .eventDetailHeaderCell, for: indexPath) as! EventDetailHeaderCell
        if isLoading {
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            cell.descriptionLbl.text = self.event.description
            cell.dateLbl.text = self.event.date
            if let urlEndPoint = self.event.image,let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(urlEndPoint)"){
                cell.eventImageView.kf.indicatorType = .activity
                cell.eventImageView.kf.setImage(with: imageURL)
            }
            
        }
        return cell
    }
    
    private func configureEventDetailCell(at indexPath: IndexPath) -> UITableViewCell{
        
        let cell = eventTableView.dequeueReusableCell(withIdentifier: .eventDetailCell, for: indexPath) as! EventDetailCell
        
        if isLoading{
            cell.setSkeletonView()
            cell.isLoading = true
        }else{
            cell.hideSkeletonView()
            cell.isLoading = false
            
            DispatchQueue.main.async {
                cell.eventsTableView.reloadData()
            }
            
            cell.delegate = self
            cell.storeIndex = (indexPath.row - 1)
            let store = self.stores[indexPath.row - 1]
            if let storeImageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(store.concept ?? "")"){
                cell.storeImageView.kf.indicatorType = .activity
                cell.storeImageView.kf.setImage(with: storeImageURL)
            }
            cell.distanceLbl.text = "\(store.distance ?? "")"
            let customType = ActiveType.custom(pattern: "\(store.name ?? ""),")
            cell.addressLbl.enabledTypes = [customType]
            cell.addressLbl.customColor[customType] = R.color.textLightBlackColor()
            cell.addressLbl.text = "\(store.name ?? ""), \(store.address ?? "")"
            cell.arrayOfDate = store.date
            
            cell.directionBtn.setTitle(PisiffikStrings.direction(), for: .normal)
            cell.backView.backgroundColor = R.color.backgroundColor()
            cell.directionBtn.tag = indexPath.row
            cell.directionBtn.addTarget(self, action: #selector(didTapDirectionBtn(_:)), for: .touchUpInside)
            
        }
        
        return cell
        
    }
    
    private func updateStoresList(stores: [EventDetailStores]){
        if !EventLocalManager.shared.getLocalEvents().isEmpty{
            if let index = EventLocalManager.shared.getLocalEvents().firstIndex(where: {$0.eventID == self.event.id}){
                let event = EventLocalManager.shared.getLocalEvents()[index]
                if !stores.isEmpty{
                    for store in stores {
                        if !event.timeData.isEmpty{
                            let strObj = self.getEventDetailStore(store: store, localTime: event.timeData)
                            self.stores.append(strObj)
                        }else{
                            let strObj = self.getEventDetailStore(store: store, localTime: [])
                            self.stores.append(strObj)
                        }
                    }
                }
            }else{
                self.stores = stores
            }
        }else{
            self.stores = stores
        }
    }
    
    private func getEventDetailStore(store: EventDetailStores,localTime: [EventTimeData]) -> EventDetailStores{
        var strObj : EventDetailStores = store
        strObj.date = []
        let storeDate = store.date
        if !storeDate.isEmpty{
            for index in (0...(storeDate.count - 1)){
//                storeDate[index].times = []
                let times = storeDate[index].times
                if !times.isEmpty, !localTime.isEmpty{
                    var dateObj : EventDetailDate = storeDate[index]
                    dateObj.times = []
                    for timeIndex in (0...(times.count - 1)) {
                        if let index = localTime.firstIndex(where: {$0.id == times[timeIndex].id}){
                            var timeObj : EventDetailTime = times[timeIndex]
                            timeObj.identifier = localTime[index].identifier
                            timeObj.isSelected = true
                            dateObj.times.append(timeObj)
                        }else{
                            var timeObj : EventDetailTime = times[timeIndex]
                            timeObj.identifier = ""
                            timeObj.isSelected = false
                            dateObj.times.append(timeObj)
                        }
                    }
                    strObj.date.append(dateObj)
                }else{
                    strObj.date = storeDate
                }
            }
        }
        return strObj
    }
    
}

//MARK: - EXTENSION FOR ALERT VC DELEGATES -

extension EventDetailVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}

//MARK: - EXTENSION FOR EventDetailCellDelegates -

extension EventDetailVC: EventDetailCellDelegates{
    
    func didTapOnEventCell(storeIndex: Int, dateIndex: Int, timeIndex: Int, isSelected: Bool) {
        
        if let storeName = self.stores[storeIndex].name,
           let eventName = self.event.name,
           let timeID = self.stores[storeIndex].date[dateIndex].times[timeIndex].id,
           let start_time = self.stores[storeIndex].date[dateIndex].times[timeIndex].startTimestamp,
           let end_time = self.stores[storeIndex].date[dateIndex].times[timeIndex].endTimestamp{
            
            let startDate = Utils.shared.getDateObjForString(start_time.UTCToLocal(incomingFormat: .UTCFormat, outGoingFormat: .LocalFormat))
            let endDate = Utils.shared.getDateObjForString(end_time.UTCToLocal(incomingFormat: .UTCFormat, outGoingFormat: .LocalFormat))
            checkPermission(eventName: eventName + " \(PisiffikStrings.at()) " + storeName, startDate: startDate, endDate: endDate, isSelected: !isSelected, eventID: self.eventID, timeID: timeID, identifier: self.stores[storeIndex].date[dateIndex].times[timeIndex].identifier ?? self.eventIdentifier,storeIndex: storeIndex, dateIndex: dateIndex, timeIndex: timeIndex)
            
        }
        
        Constants.printLogs("\(self.stores[storeIndex].name ?? ""): \(self.stores[storeIndex].date[dateIndex].times[timeIndex].startTime ?? "")")
    }
    
    private func addEventToLocalStorage(event: EventData){
        EventLocalManager.shared.saveLocalEvent(event: event)
    }
    
    private func removeEventToLocalStorage(event: EventData){
        EventLocalManager.shared.deleteLocalEvent(event: event)
    }
    
}



//MARK: - EXTENSION FOR CALENDER PERMISSION -

extension EventDetailVC{
    
    func checkPermission(eventName: String,startDate: Date,endDate: Date,isSelected: Bool,eventID: Int,timeID: Int,identifier: String,storeIndex: Int, dateIndex: Int, timeIndex: Int){
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event){
        case .notDetermined:
            eventStore.requestAccess(to: .event) { status, error in
                if status{
                    if isSelected{
                        self.removeEventToYourCalender(store: eventStore, identifier: identifier, startDate: startDate, endDate: endDate, eventName: eventName)
                        self.removeEventToLocalStorage(event: self.getEventDataObj(eventID: eventID, timeID: timeID, identifier: identifier))
                        DispatchQueue.main.async { [weak self] in
                            self?.showAlert(title: PisiffikStrings.success(), errorMessages: [PisiffikStrings.eventRemovedToCalender()])
                        }
                    }else{
                        self.addEventToYourCalender(store: eventStore, startDate: startDate, endDate: endDate, eventName: eventName,storeIndex: storeIndex, dateIndex: dateIndex, timeIndex: timeIndex)
                        self.addEventToLocalStorage(event: self.getEventDataObj(eventID: eventID, timeID: timeID, identifier: self.eventIdentifier))
                        DispatchQueue.main.async { [weak self] in
                            self?.showAlert(title: PisiffikStrings.success(), errorMessages: [PisiffikStrings.eventAddedToCalender()])
                        }
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.eventTableView.reloadData()
                    }
                }
            }
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.eventTableView.reloadData()
            }
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.enableAccessToCalenderMessage()])
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.eventTableView.reloadData()
            }
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.enableAccessToCalenderMessage()])
        case .authorized:
            if isSelected{
                self.removeEventToYourCalender(store: eventStore, identifier: identifier, startDate: startDate, endDate: endDate, eventName: eventName)
                self.removeEventToLocalStorage(event: self.getEventDataObj(eventID: eventID, timeID: timeID, identifier: identifier))
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: PisiffikStrings.success(), errorMessages: [PisiffikStrings.eventRemovedToCalender()])
                }
            }else{
                self.addEventToYourCalender(store: eventStore, startDate: startDate, endDate: endDate, eventName: eventName,storeIndex: storeIndex, dateIndex: dateIndex, timeIndex: timeIndex)
                self.addEventToLocalStorage(event: self.getEventDataObj(eventID: eventID, timeID: timeID, identifier: self.eventIdentifier))
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: PisiffikStrings.success(), errorMessages: [PisiffikStrings.eventAddedToCalender()])
                }
            }
        @unknown default:
            Constants.printLogs("Unknown")
        }
    }
    
    func addEventToYourCalender(store: EKEventStore,startDate: Date,endDate: Date,eventName: String,storeIndex: Int, dateIndex: Int, timeIndex: Int){
        let calenders = store.calendars(for: .event)
        for calender in calenders {
            if calender.title == .home{
                let event = EKEvent(eventStore: store)
                event.title = eventName
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = calender
                self.eventIdentifier = event.calendarItemIdentifier
                self.stores[storeIndex].date[dateIndex].times[timeIndex].identifier = event.calendarItemIdentifier
                do{
                    try store.save(event, span: .thisEvent)
                }catch{
                    Constants.printLogs(error.localizedDescription)
                }
            }
        }
    }
    
    func removeEventToYourCalender(store: EKEventStore,identifier: String,startDate: Date,endDate: Date,eventName: String){
        if let event = store.event(withIdentifier: identifier){
            do {
                try store.remove(event, span: .thisEvent)
            } catch {
                Constants.printLogs(error.localizedDescription)
            }
        }
    }
    
    func getEventDataObj(eventID: Int,timeID: Int,identifier: String) -> EventData{
        var event = EventData()
        event.eventID = eventID
        var time = EventTimeData()
        time.id = timeID
        time.identifier = identifier
        event.timeData = [time]
        return event
    }
    
}
