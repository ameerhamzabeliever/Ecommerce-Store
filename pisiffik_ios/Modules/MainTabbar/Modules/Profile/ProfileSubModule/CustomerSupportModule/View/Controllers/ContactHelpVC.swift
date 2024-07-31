//
//  ContactHelpVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import YPImagePicker
import MobileCoreServices
import AVFoundation

protocol CreateTicketDelegates {
    func didCreateTicket(response: AddTicketResponseData)
}

class ContactHelpVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var reasonTextFiled: UITextField!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reasonBtn: UIButton!
    @IBOutlet weak var sendBtn: LoadingButton!
    @IBOutlet weak var attachFileBtn: UIButton!
    @IBOutlet weak var attachmentBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = AddTicketViewModel()
    private var currentReasonID : String = ""
    
    var delegate : CreateTicketDelegates?
    
    let picker: YPImagePicker = {
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 3
        config.screens = [.photo, .library]
        let imgPiker = YPImagePicker(configuration: config)
        
        return imgPiker
    }()
    
    var selectedImagesData: [Data] = [Data]()
    var selectedPdfFileData : [Data] = []
    let maxCount : Int = 3
    private var isFileSizeGreater : Bool = false
    private let maxFileSize : Double = 2.0
    private var selectedImagesAttachments : [Attachment] = []
    private var isCompressed: Bool = false{
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
        attachmentBtn.isHidden = true
        homeBtn.isHidden = true
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.contactUs()
        reasonLbl.text = PisiffikStrings.reason()
        reasonTextFiled.placeholder = PisiffikStrings.select()
        subjectLbl.text = PisiffikStrings.subject()
        descriptionLbl.text = PisiffikStrings.description()
        attachFileBtn.titleLabel?.text = PisiffikStrings.attachFile()
        attachFileBtn.underline()
        attachmentBtn.setImage(R.image.ic_instock_icon(), for: .normal)
        attachmentBtn.tintColor = R.color.lightGreenColor()
        sendBtn.setTitle(PisiffikStrings.send(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        reasonLbl.font = Fonts.mediumFontsSize14
        reasonLbl.textColor = R.color.textBlueColor()
        reasonTextFiled.textColor = R.color.textBlackColor()
        subjectLbl.font = Fonts.mediumFontsSize14
        subjectLbl.textColor = R.color.textBlueColor()
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = R.color.textBlueColor()
        attachFileBtn.titleLabel?.font = Fonts.mediumFontsSize14
        attachFileBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        attachmentBtn.titleLabel?.font = Fonts.mediumFontsSize12
        attachmentBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        sendBtn.titleLabel?.font = Fonts.mediumFontsSize16
        sendBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        sendBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func addNewTicket(){
        self.sendBtn.showLoading()
        let request = AddTicketRequest(reason: self.currentReasonID, subject: self.subjectTextField.text ?? "", message: self.descriptionTextView.text)
        if !self.selectedImagesData.isEmpty{
            self.viewModel.addNewTicket(request: request, attachment: selectedImagesData,pdfData: self.selectedPdfFileData)
        }else{
            self.viewModel.addNewTicket(request: request, attachment: nil,pdfData: self.selectedPdfFileData)
        }
    }
    
    private func setEmptyFields(){
        self.currentReasonID = ""
        self.reasonTextFiled.text = ""
        self.subjectTextField.text = ""
        self.descriptionTextView.text = ""
        self.selectedImagesAttachments.removeAll()
        self.selectedImagesData.removeAll()
        self.selectedPdfFileData.removeAll()
        self.attachmentBtn.isHidden = true
        self.isFileSizeGreater = false
        self.isCompressed = false
        self.checkFileSize()
    }
    
    private func checkFileSize(){
        if isFileSizeGreater{
            attachmentBtn.setImage(R.image.ic_file_error_icon(), for: .normal)
            attachmentBtn.tintColor = R.color.textRedColor()
            attachmentBtn.setTitleColor(R.color.textRedColor(), for: .normal)
        }else{
            attachmentBtn.setImage(R.image.ic_instock_icon(), for: .normal)
            attachmentBtn.tintColor = R.color.lightGreenColor()
            attachmentBtn.setTitleColor(R.color.textBlueColor(), for: .normal)
        }
    }
    
    private func setViewAttacmentBtnLoading(){
        if isCompressed{
            self.attachmentBtn.showLoading()
        }else{
            self.attachmentBtn.hideLoading()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.checkFileSize()
                if self.selectedPdfFileData.isEmpty{
                    Constants.printLogs("\(self.selectedImagesAttachments.count)")
                    self.attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachments.count))"
                    self.attachmentBtn.underline()
                }else{
                    self.attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachments.count + self.selectedPdfFileData.count))"
                    self.attachmentBtn.underline()
                }
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton) {
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    @IBAction func didTapReasonBtn(_ sender: UIButton) {
        sender.showAnimation {
            if Network.isAvailable{
                guard let reasonVC = R.storyboard.contactServiceSB.ticketReasonVC() else {return}
                reasonVC.delegate = self
                self.present(reasonVC, animated: true)
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
            }
        }
    }
    
    @IBAction func didTapAttachFileBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.showPickerSheet()
        }
    }
    
    @IBAction func didTapSeeAllAttachments(_ sender: UIButton){
        sender.showAnimation {
            if !self.isCompressed{
                guard let attachmentsVC = R.storyboard.contactServiceSB.attacmentsVC() else {return}
                attachmentsVC.images = self.selectedImagesAttachments
                attachmentsVC.imagesData = self.selectedImagesData
                attachmentsVC.pdfFiles = self.selectedPdfFileData
                attachmentsVC.delegate = self
                attachmentsVC.mode = .byDefault
                self.navigationController?.pushViewController(attachmentsVC, animated: true)
            }
        }
    }
    
    @IBAction func didTapSendBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.sendBtn.isAnimating{
                if !self.isCompressed{
                    if (self.selectedImagesData.count + self.selectedPdfFileData.count) < 4{
                        if !self.isFileSizeGreater{
                            self.addNewTicket()
                        }else{
                            self.showAlert(title: PisiffikStrings.alert(), errorMessages: ["\(PisiffikStrings.youCanOnlySendMaximum()) \(self.maxFileSize) \(PisiffikStrings.mb()) \(PisiffikStrings.fileSize())"])
                        }
                    }else{
                        self.showAlert(title: PisiffikStrings.alert(), errorMessages: ["\(PisiffikStrings.youCanOnlSelectMaximum()) \(self.maxCount) \(PisiffikStrings.attacments())"])
                    }
                }
            }
        }
    }
    
    
}


//MARK: - EXTENSION FOR ADD TICKET VIEW MODEL DELEGATE -

extension ContactHelpVC: AddTicketViewModelDelegate{
    
    func didReceiveAddTicket(response: AddTicketResponse) {
        self.sendBtn.hideLoading()
        if let responseData = response.data, let ticketDetail = responseData.ticket?.ticketDetail{
            self.delegate?.didCreateTicket(response: responseData)
            self.setEmptyFields()
            guard let ticketDetailVC = R.storyboard.profileSB.ticketDetailVC() else {return}
            ticketDetailVC.currentTicket = ticketDetail
            self.push(controller: ticketDetailVC, hideBar: true, animated: true)
            
        }
       
    }
    
    func didReceiveAddTicketListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.sendBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        self.sendBtn.hideLoading()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        self.sendBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}

//MARK: - EXTENSION FOR ATTACHMENT DELEGATES -

extension ContactHelpVC: AttachmentDelegates{
    
    func didUpdateAttachments(images: [Attachment],imageData: [Data], pdfFiles: [Data]) {
        self.isFileSizeGreater = false
        self.checkFileSize()
        if images.isEmpty && pdfFiles.isEmpty{
            self.attachmentBtn.isHidden = true
            self.selectedImagesAttachments = []
            self.selectedPdfFileData = []
            self.selectedImagesData = []
            self.isFileSizeGreater = false
            self.checkFileSize()
            
        }else if !images.isEmpty && pdfFiles.isEmpty{
            self.attachmentBtn.isHidden = false
            self.selectedImagesAttachments = images
            self.selectedImagesData = imageData
            self.selectedPdfFileData = []
            attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(selectedImagesAttachments.count))"
            self.checkGivenImage(data: imageData)
            self.checkFileSize()
            attachmentBtn.underline()
            
        }else if images.isEmpty && !pdfFiles.isEmpty{
            self.attachmentBtn.isHidden = false
            self.selectedImagesAttachments = images
            self.selectedPdfFileData = pdfFiles
            attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedPdfFileData.count))"
            self.selectedImagesData = []
            self.checkGivenPdf(data: pdfFiles)
            self.checkFileSize()
            attachmentBtn.underline()
            
        }else{
            self.attachmentBtn.isHidden = false
            self.selectedImagesAttachments = images
            self.selectedImagesData = imageData
            self.selectedPdfFileData = pdfFiles
            attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(selectedImagesAttachments.count + self.selectedPdfFileData.count))"
            self.checkGivenImage(data: imageData)
            self.checkGivenPdf(data: pdfFiles)
            self.checkFileSize()
            attachmentBtn.underline()
            
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

//MARK: - EXTENSION FOR REASON DELEGATES -

extension ContactHelpVC: TicketReasonProtocol{
    
    func didSelectReasonWith(name: String, id: Int) {
        self.reasonTextFiled.text = name
        self.currentReasonID = String(id)
    }
    
}


//MARK: - EXTENSION FOR PICKINGUP ATTACHMENTS -

extension ContactHelpVC: StoreHelpVCDelegates{
    
    private func selectAttachment(){
        
        self.picker.didFinishPicking { [unowned self] items, cancelled in
            self.selectedImagesAttachments.removeAll()
            self.selectedImagesData.removeAll()
            if !items.isEmpty{
                for index in (0...(items.count - 1)) {
                    switch items[index] {
                    case .photo(let photo):
                        
                        self.attachmentBtn.isHidden = false
                        self.isCompressed = true
                        
                        ImageCompressor.compress(image: photo.image, maxByte: 1000000) { imageReceived in
                            
                            if let imageReceived = imageReceived,
                               let imageData = imageReceived.pngData()
                            {
                                self.selectedImagesData.append(imageData)
                                let imageSize = imageData.getSizeInMB()
                                let attahment = Attachment(image: photo.image, pdf: nil, size: imageSize)
                                self.selectedImagesAttachments.append(attahment)
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
//            if selectedPdfFileData.isEmpty{
//                attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(items.count))"
//                attachmentBtn.underline()
//            }else{
//                attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(items.count + self.selectedPdfFileData.count))"
//                attachmentBtn.underline()
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
            actionSheet.popoverPresentationController?.sourceView = attachFileBtn
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
}


//MARK: - EXTENSION FOR DOCUMENT PICKER DELEGATES -

extension ContactHelpVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls{
            guard let data = NSData(contentsOf: url) else {
                return
            }
            let fileData = data as Data
            self.selectedPdfFileData.append(data as Data)
            if fileData.getSizeInMB() > self.maxFileSize{
                self.isFileSizeGreater = true
            }
        }
        self.checkFileSize()
        attachmentBtn.isHidden = false
        attachmentBtn.titleLabel?.text = "\(PisiffikStrings.viewFile()) (\(self.selectedImagesAttachments.count + self.selectedPdfFileData.count))"
        attachmentBtn.underline()
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
