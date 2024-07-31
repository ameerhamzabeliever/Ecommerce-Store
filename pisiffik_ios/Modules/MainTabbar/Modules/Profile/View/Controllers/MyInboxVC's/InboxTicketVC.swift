//
//  InboxTicketVC.swift
//  pisiffik_ios
//
//  Created by APPLE on 6/17/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import IQKeyboardManagerSwift

class InboxTicketVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var notificationTableView: UITableView!{
        didSet{
            notificationTableView.delegate = self
            notificationTableView.dataSource = self
            notificationTableView.register(R.nib.ticketsCell)
        }
    }
    @IBOutlet weak var addTicketBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = InboxTicketViewModel()
    private var ticketList : [TicketList] = []
    private var isLoading : Bool = false{
        didSet{
            notificationTableView.reloadData()
        }
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.viewModel.delegate = self
        getTicketList()
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
    
    private func getTicketList(){
        
        if !Network.isAvailable{
            self.notificationTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.isLoading = true
                self.viewModel.getInboxTicketList()
            }
        }else{
            self.isLoading = true
            self.viewModel.getInboxTicketList()
        }
        
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapAddTicketBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.isLoading{
                guard let addTicketVC = R.storyboard.contactServiceSB.contactHelpVC() else {return}
                addTicketVC.delegate = self
                self.push(controller: addTicketVC, hideBar: true, animated: true)
            }
        }
    }
    
    
}

//MARK: - EXTENSION FOR TICKET VIEW MODEL DELEGATES -

extension InboxTicketVC: InboxTicketViewModelDelegate{
    
    func didReceiveTicketList(response: TicketListResponse) {
        isLoading = false
        if let list = response.data?.tickets{
            if !list.isEmpty{
                self.ticketList = list
                DispatchQueue.main.async { [weak self] in
                    self?.notificationTableView.reloadData()
                }
            }else{
                self.notificationTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.notificationTableView.reloadData()
            }
        }
    }
    
    func didReceiveTicketListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
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
            self.viewModel.getInboxTicketList()
        }
    }
    
}


//MARK: - EXTENSION FOR NEWS LIST VIEW METHODS -

extension InboxTicketVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 15 : ticketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureTicketsCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading{ return }
        ticketList[indexPath.row].unreadMsgCount = 0
        self.notificationTableView.reloadData()
        if ticketList[indexPath.row].status != 3{
            guard let ticketDetailVC = R.storyboard.profileSB.ticketDetailVC() else {return}
            ticketDetailVC.currentTicket = ticketList[indexPath.row]
            self.push(controller: ticketDetailVC, hideBar: true, animated: true)
        }else{
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.ticketClosedError()])
            }
        }
    }
    
}

//MARK: - EXTENSION FOR NEWS CELL -

extension InboxTicketVC{
    
    private func configureTicketsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: .ticketsCell, for: indexPath) as! TicketsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            
            cell.hideSkeletonView()
            let ticket = ticketList[indexPath.row]
            cell.ticketsImage.image = R.image.ic_ticket_icon()
            cell.headingLbl.text = ticket.subject
            cell.ticketNmbLbl.text = "\(PisiffikStrings.ticket())# \(ticket.id ?? 0)  |"
            cell.dateLbl.text = ticket.createdAt
            
            let closeType = ActiveType.custom(pattern: "\(PisiffikStrings.closed())")
            let openType = ActiveType.custom(pattern: "\(PisiffikStrings.open())")
            let pendingType = ActiveType.custom(pattern: "\(PisiffikStrings.pending())")
            let reOpenType = ActiveType.custom(pattern: "\(PisiffikStrings.reOpened())")
            
            cell.statusLbl.enabledTypes = [closeType, openType, pendingType, reOpenType]
            cell.statusLbl.customColor[closeType] = R.color.textLightGrayColor()
            cell.statusLbl.customColor[openType] = R.color.lightGreenColor()
            cell.statusLbl.customColor[pendingType] = R.color.textLightGrayColor()
            cell.statusLbl.customColor[reOpenType] = R.color.lightGreenColor()
            
            if ticket.unreadMsgCount == 0{
                cell.notificationReadImage.isHidden = true
            }else{
                cell.notificationReadImage.isHidden = false
            }
            
            if ticket.status == 1{
                cell.statusLbl.text = "\(PisiffikStrings.status()): \(PisiffikStrings.pending())"
            }else if ticket.status == 2{
                cell.statusLbl.text = "\(PisiffikStrings.status()): \(PisiffikStrings.open())"
            }else if ticket.status == 3{
                cell.statusLbl.text = "\(PisiffikStrings.status()): \(PisiffikStrings.closed())"
            }else{
                cell.statusLbl.text = "\(PisiffikStrings.status()): \(PisiffikStrings.reOpened())"
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR CREATE TICKET DELEGATES -

extension InboxTicketVC: CreateTicketDelegates{
    
    func didCreateTicket(response: AddTicketResponseData) {
        
        if let ticketObj = response.ticket?.ticketDetail{
            self.ticketList.insert(ticketObj, at: 0)
            DispatchQueue.main.async { [weak self] in
                self?.notificationTableView.reloadData()
            }
        }
        
    }
    
}
