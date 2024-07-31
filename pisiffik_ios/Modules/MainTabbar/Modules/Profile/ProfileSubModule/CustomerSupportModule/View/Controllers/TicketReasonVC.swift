//
//  TicketReasonVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol TicketReasonProtocol{
    func didSelectReasonWith(name: String,id: Int)
}

class TicketReasonVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var reasonTableView: ContentSizedTableView!{
        didSet{
            reasonTableView.delegate = self
            reasonTableView.dataSource = self
            reasonTableView.register(R.nib.ticketReasonCell)
        }
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableBackView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private var isLoading : Bool = false
    var delegate: TicketReasonProtocol?
    private var arrayOfReason : [TicketReasons] = []
    private var viewModel = TicketReasonViewModel()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getReasons()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        
    }
    
    func setUI() {
        tableBackView.layer.cornerRadius = 20
        tableBackView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getReasons(){
        if Network.isAvailable{
            self.viewModel.getNewTicketReason()
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - EXTENSION FOR REASON VIEW MODEL DELEGATES -

extension TicketReasonVC: TicketReasonViewModelDelegate{
    
    func didReceiveTicketReason(response: TicketReasonResponse) {
        isLoading = false
        if let list = response.data?.reasons{
            if !list.isEmpty{
                self.arrayOfReason = list
                DispatchQueue.main.async { [weak self] in
                    self?.reasonTableView.reloadData()
                }
            }else{
                self.reasonTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                self.reasonTableView.reloadData()
            }
        }
    }
    
    func didReceiveAddTicketListResponseWithWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.reasonTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.reasonTableView.reloadData()
        self.reasonTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.viewModel.getNewTicketReason()
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension TicketReasonVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : self.arrayOfReason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return configureReasonCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        guard let reasonName = self.arrayOfReason[indexPath.row].name, let reasonID = self.arrayOfReason[indexPath.row].id else { return }
        self.delegate?.didSelectReasonWith(name: reasonName, id: reasonID)
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - EXTENSION FOR FILTER CELLS -

extension TicketReasonVC{
    
    private func configureReasonCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = reasonTableView.dequeueReusableCell(withIdentifier: .ticketReasonCell, for: indexPath) as! TicketReasonCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            cell.nameLbl.text = self.arrayOfReason[indexPath.row].name
            cell.seperator.isHidden = true
            
        }
        
        return cell
    }
    
}
