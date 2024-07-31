//
//  TicketDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import YPImagePicker
import MobileCoreServices
import IQKeyboardManagerSwift
import AVFoundation
import Photos

struct ReplyModel{
    let name: String
    let date: String
    let message: String
    let currentUser: Bool
    let haveAttachment: Bool
    let attachment: String?
}

class TicketDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var sendBtn: LoadingButton!
    @IBOutlet weak var replyTableView: UITableView!{
        didSet{
            replyTableView.delegate = self
            replyTableView.dataSource = self
            replyTableView.register(R.nib.inboxReplyCell)
            replyTableView.register(R.nib.ticketDetailHeaderCell)
            replyTableView.rowHeight = UITableView.automaticDimension
            replyTableView.estimatedRowHeight = 45.0
        }
    }
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var viewFileBtn: LoadingButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - PROPERTIES -
    
    var currentTicket = TicketList()
    let replyPlaceholder : String = ""
    private var viewModel = TicketDetailViewModel()
    private var isLoading : Bool = false{
        didSet{
            self.replyTableView.reloadData()
        }
    }
    
    var messages : [TicketDetailMessages] = []
    
    let picker: YPImagePicker = {
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 3
        config.screens = [.photo, .library]
        let imgPiker = YPImagePicker(configuration: config)
        
        return imgPiker
    }()
    
    var selectedImagesAttachment: [Attachment] = [Attachment]()
    var selectedImagesData: [Data] = [Data]()
    var pdfFileData : [Data] = []
    let maxCount : Int = 3
    private var isFileSizeGreater : Bool = false
    private let maxFileSize : Double = 2.0
    private var isCompressed : Bool = false{
        didSet{
            self.setViewAttacmentBtnLoading()
        }
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.viewModel.delegate = self
        getMessages()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        startObservingKeyboardChanges()
        UserDefault.shared.saveTicketDetailVC(open: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        stopObservingKeyboardChanges()
        UserDefault.shared.saveTicketDetailVC(open: false)
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.tickets()
        attachBtn.titleLabel?.text = PisiffikStrings.attachFile()
        attachBtn.underline()
        viewFileBtn.isHidden = true
        viewFileBtn.setImage(R.image.ic_instock_icon(), for: .normal)
        viewFileBtn.tintColor = R.color.lightGreenColor()
        sendBtn.setImage(R.image.ic_send_icon(), for: .normal)

    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        attachBtn.titleLabel?.font = Fonts.mediumFontsSize12
        attachBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        viewFileBtn.titleLabel?.font = Fonts.mediumFontsSize12
        viewFileBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        sendBtn.titleLabel?.font = Fonts.mediumFontsSize14
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.backgroundColor = R.color.darkBlueColor()
        //In Case of No Reply...
        replyTextView.text = self.replyPlaceholder
        replyTextView.textColor = R.color.textLightGrayColor()
        replyTextView.delegate = self
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getMessages(){
        isLoading = true
        guard let ticketID = self.currentTicket.id else {return}
        self.viewModel.getTicketMessageBy(id: ticketID)
    }
    
    private func checkFileSize(){
        if isFileSizeGreater{
            viewFileBtn.setImage(R.image.ic_file_error_icon(), for: .normal)
            viewFileBtn.tintColor = R.color.textRedColor()
            viewFileBtn.setTitleColor(R.color.textRedColor(), for: .normal)
        }else{
            viewFileBtn.setImage(R.image.ic_instock_icon(), for: .normal)
            viewFileBtn.tintColor = R.color.lightGreenColor()
            viewFileBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        }
    }
    
    private func setViewAttacmentBtnLoading(){
        if isCompressed{
            self.viewFileBtn.showLoading()
        }else{
            self.viewFileBtn.hideLoading()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.checkFileSize()
                if self.pdfFileData.isEmpty{
                    Constants.printLogs("\(self.selectedImagesAttachment.count)")
                    self.viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachment.count))"
                    self.viewFileBtn.underline()
                }else{
                    self.viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachment.count + self.pdfFileData.count))"
                    self.viewFileBtn.underline()
                }
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAttachBtn(_ sender: UIButton){
        sender.showAnimation {
            self.showPickerSheet()
        }
    }
    
    @IBAction func didTapSendBtn(_ sender: UIButton){
        sender.showAnimation {
            if !self.isLoading && !self.isCompressed && !self.sendBtn.isAnimating{
                if self.replyTextView.text != self.replyPlaceholder{
                    guard let ticketID = self.currentTicket.id else {return}
                    if (self.selectedImagesData.count + self.pdfFileData.count) < 4{
                        if Network.isAvailable{
                            if !self.isFileSizeGreater{
                                self.sendBtn.showLoading()
                                self.replyTextView.resignFirstResponder()
                                if !self.selectedImagesData.isEmpty{
                                    self.viewModel.didSendTicket(message: self.replyTextView.text, ticketID: String(ticketID), attachmentData: self.selectedImagesData, pdfData: self.pdfFileData)
                                }else{
                                    self.viewModel.didSendTicket(message: self.replyTextView.text, ticketID: String(ticketID), attachmentData: nil, pdfData: self.pdfFileData)
                                }
                            }else{
                                self.showAlert(title: PisiffikStrings.alert(), errorMessages: ["\(PisiffikStrings.youCanOnlySendMaximum()) \(self.maxFileSize) \(PisiffikStrings.mb()) \(PisiffikStrings.fileSize())"])
                            }
                        }else{
                            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                        }
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: ["\(PisiffikStrings.youCanOnlSelectMaximum()) \(self.maxCount) \(PisiffikStrings.attacments())"])
                    }
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.messageRequired()])
                }
            }
        }
    }
    
    @IBAction func didTapViewFileBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.isCompressed{
                guard let attachmentsVC = R.storyboard.contactServiceSB.attacmentsVC() else {return}
                attachmentsVC.images = self.selectedImagesAttachment
                attachmentsVC.imagesData = self.selectedImagesData
                attachmentsVC.pdfFiles = self.pdfFileData
                attachmentsVC.delegate = self
                attachmentsVC.mode = .byDefault
                self.navigationController?.pushViewController(attachmentsVC, animated: true)
            }
        }
    }
    
}

//MARK: - EXTENSION FOR TICKET DETAIL VIEW MODEL -

extension TicketDetailVC: TicketDetailViewModelDelegate{
    
    func didReceiveTicketMessages(response: TicketDetailResponse) {
        isLoading = false
        if let messsages = response.data?.messasgesList{
            if !messsages.isEmpty{
                self.messages = messsages
            }
            DispatchQueue.main.async { [weak self] in
                self?.replyTableView.reloadData()
                self?.replyTableView.scrollToBottomRow()
            }
        }
    }
    
    func didReceiveTicketMessagesResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    
    func didReceiveTicketSendMessage(response: TicketMessageResponse) {
        self.sendBtn.hideLoading()
        if let resData = response.data?.message{
            self.messages.append(resData)
            self.replyTextView.text = self.replyPlaceholder
            self.viewFileBtn.isHidden = true
            self.selectedImagesData = []
            self.selectedImagesAttachment = []
            self.pdfFileData = []
            self.isFileSizeGreater = false
            self.checkFileSize()
            self.replyTableView.reloadData()
            self.replyTableView.scrollToBottomRow()
        }
    }
    
    func didReceiveTicketSendMessageResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.sendBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.replyTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) { [weak self] in
            guard let ticketID = self?.currentTicket.id else {return}
            self?.viewModel.getTicketMessageBy(id: ticketID)
        }
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension TicketDetailVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : messages.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return configureHeaderCell(at: indexPath)
        }else{
            return configureReplyCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLoading ? 80.0 : UITableView.automaticDimension
    }

    
}

//MARK: - EXTENSION FOR REPLY CELL -

extension TicketDetailVC{
    
    private func configureHeaderCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = replyTableView.dequeueReusableCell(withIdentifier: .ticketDetailHeaderCell, for: indexPath) as! TicketDetailHeaderCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            
            cell.hideSkeletonView()
            
            cell.ticketNmbLbl.text = "\(PisiffikStrings.ticket())# \(currentTicket.id ?? 0)"
            cell.dateLbl.text = currentTicket.updatedAt
            cell.subjectNameLbl.text = currentTicket.subject
            cell.reasonNameLbl.text = currentTicket.reason
            
            if currentTicket.status == 1{
                cell.openLbl.text = "\(PisiffikStrings.pending())"
                cell.openLbl.textColor = R.color.textLightGrayColor()
            }else if currentTicket.status == 2{
                cell.openLbl.text = "\(PisiffikStrings.open())"
                cell.openLbl.textColor = R.color.lightGreenColor()
            }else if currentTicket.status == 3{
                cell.openLbl.text = "\(PisiffikStrings.closed())"
                cell.openLbl.textColor = R.color.textLightGrayColor()
            }else{
                cell.openLbl.text = "\(PisiffikStrings.reOpened())"
                cell.openLbl.textColor = R.color.lightGreenColor()
            }
            
        }
        
        return cell
    }
    
    private func configureReplyCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = replyTableView.dequeueReusableCell(withIdentifier: .inboxReplyCell, for: indexPath) as! InboxReplyCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            
            cell.replyLbl.text = messages[indexPath.row - 1].message
            
            if messages[indexPath.row - 1].agent != nil{
                cell.nameLbl.text = messages[indexPath.row - 1].agent?.fullName
                cell.nameLbl.textColor = R.color.textBlackColor()
                cell.dateLbl.text = messages[indexPath.row - 1].date
                cell.dateLbl.textColor = R.color.textLightGrayColor()
                cell.replyBackView.backgroundColor = R.color.newBgColor()
                cell.replyLbl.textColor = R.color.textGrayColor()
                cell.attachmentBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
                cell.attachmentBtn.tintColor = R.color.textGrayColor()
                
            }else{
                cell.nameLbl.text = messages[indexPath.row - 1].date
                cell.nameLbl.textColor = R.color.textLightGrayColor()
                cell.dateLbl.text = messages[indexPath.row - 1].customer?.fullName
                cell.dateLbl.textColor = R.color.textBlackColor()
                cell.replyBackView.backgroundColor = R.color.lightBlueColor()
                cell.replyLbl.textColor = R.color.textWhiteColor()
                cell.attachmentBtn.setTitleColor(.white, for: .normal)
                cell.attachmentBtn.tintColor = R.color.textWhiteColor()
            }
            
            if !(messages[indexPath.row - 1].attachment?.isEmpty ?? false){
                cell.seperatorView.isHidden = false
                cell.attachmentBtn.isHidden = false
                cell.attachmentBtn.setTitle("\(PisiffikStrings.viewFile()) (\(messages[indexPath.row - 1].attachment?.count ?? 0))", for: .normal)
            }else{
                cell.seperatorView.isHidden = true
                cell.attachmentBtn.isHidden = true
            }
            
            cell.attachmentBtn.addTapGestureRecognizer { [weak self] in
                if let attacment = self?.messages[indexPath.row - 1].attachment{
                    guard let attacmentVC = R.storyboard.contactServiceSB.attacmentsVC() else {return}
                    attacmentVC.arrayOfAttachments = attacment
                    attacmentVC.mode = .ticketDetail
                    self?.navigationController?.pushViewController(attacmentVC, animated: true)
                }
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR TEXT VIEW DELEGATES -

extension TicketDetailVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if replyTextView.textColor == R.color.textLightGrayColor() {
            replyTextView.text = ""
            replyTextView.textColor = R.color.textBlackColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if replyTextView.text == "" {
            replyTextView.text = self.replyPlaceholder
            replyTextView.textColor = R.color.textLightGrayColor()
        }
    }
    
}



//MARK: - EXTENSION FOR ATTACHMENT DELEGATES -

extension TicketDetailVC: AttachmentDelegates{
    
    func didUpdateAttachments(images: [Attachment],imageData: [Data], pdfFiles: [Data]) {
        self.isFileSizeGreater = false
        self.checkFileSize()
        if images.isEmpty && pdfFiles.isEmpty{
            self.viewFileBtn.isHidden = true
            self.selectedImagesAttachment = []
            self.pdfFileData = []
            self.selectedImagesData = []
            self.isFileSizeGreater = false
            self.checkFileSize()
            
        }else if !images.isEmpty && pdfFiles.isEmpty{
            self.viewFileBtn.isHidden = false
            self.selectedImagesAttachment = images
            self.pdfFileData = []
            self.selectedImagesData = imageData
            viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(selectedImagesAttachment.count))"
            self.checkGivenImage(data: imageData)
            self.checkFileSize()
            viewFileBtn.underline()
            
        }else if images.isEmpty && !pdfFiles.isEmpty{
            self.viewFileBtn.isHidden = false
            self.selectedImagesAttachment = images
            self.pdfFileData = pdfFiles
            viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.pdfFileData.count))"
            self.selectedImagesData = []
            self.checkGivenPdf(data: pdfFiles)
            self.checkFileSize()
            viewFileBtn.underline()
            
        }else{
            self.viewFileBtn.isHidden = false
            self.selectedImagesAttachment = images
            self.selectedImagesData = imageData
            self.pdfFileData = pdfFiles
            viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(selectedImagesAttachment.count + self.pdfFileData.count))"
            self.checkGivenImage(data: imageData)
            self.checkGivenPdf(data: pdfFiles)
            self.checkFileSize()
            viewFileBtn.underline()
            
        }
        
    }
    
    private func checkGivenImage(data: [Data]){
        for data in data{
            if data.getSizeInMB() > self.maxFileSize{
                self.isFileSizeGreater = true
            }
        }
    }
    
    private func checkGivenPdf(data: [Data]){
        for data in data{
            if data.getSizeInMB() > self.maxFileSize{
                self.isFileSizeGreater = true
            }
        }
    }
    
    
}


//MARK: - EXTENSION FOR PICKINGUP ATTACHMENTS -

extension TicketDetailVC: StoreHelpVCDelegates{
    
    private func selectAttachment(){
        
        self.picker.didFinishPicking { [unowned self] items, cancelled in
            self.selectedImagesAttachment.removeAll()
            self.selectedImagesData.removeAll()
            if !items.isEmpty{
                for index in (0...(items.count - 1)) {
                    switch items[index] {
                    case .photo(let photo):
                        
                        self.viewFileBtn.isHidden = false
                        self.isCompressed = true
                        
                        ImageCompressor.compress(image: photo.image, maxByte: 1000000) { imageReceived in
                            
                            if let imageReceived = imageReceived,
                               let imageData = imageReceived.pngData()
                            {
                                self.selectedImagesData.append(imageData)
                                let imageSize = imageData.getSizeInMB()
                                let attahment = Attachment(image: photo.image, pdf: nil, size: imageSize)
                                self.selectedImagesAttachment.append(attahment)
                                if imageData.getSizeInMB() > self.maxFileSize{
                                    self.isFileSizeGreater = true
                                }
                                if index == (items.count - 1){
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.isCompressed = false
                                    }
                                }
                            }
                            
                        }
                        
                    case .video(let video):
                        print(video)
                    }
                }
            }
            
//            self.checkFileSize()
//
//            if pdfFileData.isEmpty{
//                viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(items.count))"
//                viewFileBtn.underline()
//            }else{
//                viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(items.count + self.pdfFileData.count))"
//                viewFileBtn.underline()
//            }
            
            self.picker.dismiss(animated: true, completion: nil)
        }
        self.present(self.picker, animated: true)
        
    }
    
    private func showDocuments(){
        let documentVC = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentVC.delegate = self
        documentVC.allowsMultipleSelection = true
        documentVC.modalPresentationStyle = .formSheet
        self.present(documentVC, animated: true, completion: nil)
    }
    
    private func showPickerSheet(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.black
        
        let fromCameraAction = UIAlertAction(title: PisiffikStrings.fromGallery(), style: .default) { [weak self] _ in
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { success in
                DispatchQueue.main.async { [weak self] in
                    if success{
                        self?.selectAttachment()
                    }else{
                        self?.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.cameraPermissionNeeded(), delegate: self)
                    }
                }
            })
        }
        
        let fromDocumentsAction = UIAlertAction(title: PisiffikStrings.fromDocuments(), style: .default) { [weak self] _ in
            self?.showDocuments()
        }
        
        let cancelAction = UIAlertAction(title: PisiffikStrings.cancel(), style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        actionSheet.addAction(fromCameraAction)
        actionSheet.addAction(fromDocumentsAction)
        actionSheet.addAction(cancelAction)
        
        if UIDevice().userInterfaceIdiom == .phone{
            self.present(actionSheet, animated: true)
        }else{
            actionSheet.popoverPresentationController?.sourceView = attachBtn
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}


//MARK: - EXTENSION FOR DOCUMENT PICKER DELEGATES -

extension TicketDetailVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls{
            guard let data = NSData(contentsOf: url) else {
                return
            }
            let fileData = data as Data
            self.pdfFileData.append(fileData)
            if fileData.getSizeInMB() > self.maxFileSize{
                self.isFileSizeGreater = true
            }
        }
        
        self.checkFileSize()
        viewFileBtn.isHidden = false
        viewFileBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachment.count + self.pdfFileData.count))"
        viewFileBtn.underline()
//        print("Data: \(data) of URL:\(myURL) with name: \(myURL.lastPathComponent)")
        
    }


    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        self.dismiss(animated: true, completion: nil)
        
    }
}

//MARK: - EXTENSION FOR KeyboardHandler -

extension TicketDetailVC: KeyboardHandler{
    
    
}
