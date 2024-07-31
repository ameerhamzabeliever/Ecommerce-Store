//
//  AttacmentsVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ImageViewer_swift
import Lightbox
import PDFKit

enum AttacmentMode{
    case ticketDetail
    case byDefault
}

protocol AttachmentDelegates{
    func didUpdateAttachments(images: [Attachment],imageData: [Data],pdfFiles: [Data])
}

struct Attachment{
    let image: UIImage?
    let pdf: Data?
    let size: Double
}

class AttacmentsVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var attachmentTableView: UITableView!{
        didSet{
            attachmentTableView.delegate = self
            attachmentTableView.dataSource = self
            attachmentTableView.register(R.nib.attacmentCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    var delegate : AttachmentDelegates?
    var images : [Attachment] = []
    var imagesData : [Data] = []
    var pdfFiles : [Data] = []
    var arrayOfAttachments : [TicketAttacment] = []
    private var arrayOfFileSize : [Double] = []
    private let maxFileSize : Double = 2.0
    
    var mode : AttacmentMode = {
        let mode : AttacmentMode = .byDefault
        return mode
    }()
    
    let attacmentBaseURL : String = "https://pisiffik.s3.eu-north-1.amazonaws.com/attachments/"
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        convertDataToDouble()
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.attacments()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func lightBoxController(imageURL: URL){
        
        let images = LightboxImage(imageURL: imageURL)
        
        let controller = LightboxController(images: [images])
        
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.footerView.isHidden = true
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
        
    }
    
    private func lightBoxController(image: UIImage){
        
        let images = LightboxImage(image: image)
        
        let controller = LightboxController(images: [images])
        
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.footerView.isHidden = true
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
        
    }
    
    private func convertDataToDouble(){
        for image in self.images{
            self.arrayOfFileSize.append(image.size)
        }
        for file in pdfFiles {
            self.arrayOfFileSize.append(file.getSizeInMB())
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.delegate?.didUpdateAttachments(images: self.images,imageData: self.imagesData, pdfFiles: self.pdfFiles)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension AttacmentsVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .byDefault{
            return images.count + pdfFiles.count
        }else{
            return arrayOfAttachments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mode == .byDefault{
            return configureDefaultCell(at: indexPath)
        }else{
            return configureTicketAttachmentsCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .ticketDetail{
            let attachment = arrayOfAttachments[indexPath.row]
            Constants.printLogs("\(self.attacmentBaseURL)\(attachment.attachmentName ?? "")")
            if attachment.attachmentName?.last == "f"{
                if let url = URL(string: "\(self.attacmentBaseURL)\(attachment.attachmentName ?? "")"){
                    UIApplication.shared.open(url)
                }
//                let urlString = "\(self.attacmentBaseURL)\(attachment.attachmentName ?? "")"
//                guard let pdfViewVC = R.storyboard.contactServiceSB.pdfViewVC() else {return}
//                pdfViewVC.pdfURL = urlString
//                pdfViewVC.mode = .url
//                self.present(pdfViewVC, animated: false)
                
            }else{
                if let url = URL(string: "\(self.attacmentBaseURL)\(attachment.attachmentName ?? "")"){
                   lightBoxController(imageURL: url)
                }
                
            }
        }else{
            if indexPath.row < images.count{
                if let image = self.images[indexPath.row].image{
                    lightBoxController(image: image)
                }
                
            }else{
                guard let pdfViewVC = R.storyboard.contactServiceSB.pdfViewVC() else {return}
                pdfViewVC.pdfData = self.pdfFiles[indexPath.row - self.images.count]
                pdfViewVC.mode = .local
                self.present(pdfViewVC, animated: false)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == .byDefault{
            return 90.0
        }else{
            return UITableView.automaticDimension
        }
    }
    
}

//MARK: - EXTENSION FOR CONFIGURE CELL -

extension AttacmentsVC{
    
    private func configureDefaultCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = attachmentTableView.dequeueReusableCell(withIdentifier: .attacmentCell, for: indexPath) as! AttacmentCell
        
        if indexPath.row < images.count{
            cell.fileNameLbl.text = "\(PisiffikStrings.photo()) (\(indexPath.row + 1)).png"
        }else{
            cell.fileNameLbl.text = "\(PisiffikStrings.document()).pdf"
        }
        cell.fileSizeLbl.text = "\(self.arrayOfFileSize[indexPath.row]) \(PisiffikStrings.mb())"

        if self.arrayOfFileSize[indexPath.row] > self.maxFileSize{
            cell.backView.backgroundColor = .appLightRedBgColor
            cell.backView.layer.borderColor = R.color.textRedColor()?.cgColor
            cell.fileImageView.image = R.image.ic_file_error_icon()
        }else{
            cell.backView.backgroundColor = R.color.greenBGColor()
            cell.backView.layer.borderColor = .appLightGreenCgColor
            if indexPath.row < images.count {
                cell.fileImageView.image = R.image.image_icon()
            }else{
                cell.fileImageView.image = R.image.file_icon()
            }
        }
        
        cell.cancelBtn.addTapGestureRecognizer { [weak self] in
            guard let self = self else {return}
            self.arrayOfFileSize.remove(at: indexPath.row)
            if indexPath.row < self.images.count{
                self.imagesData.remove(at: indexPath.row)
                self.images.remove(at: indexPath.row)
                self.attachmentTableView.reloadData()
            }else{
                self.pdfFiles.remove(at: indexPath.row - self.images.count)
                self.attachmentTableView.reloadData()
            }
        }
        return cell
    }
    
    private func configureTicketAttachmentsCell(at indexPath: IndexPath) -> UITableViewCell{
        
        let cell = attachmentTableView.dequeueReusableCell(withIdentifier: .attacmentCell, for: indexPath) as! AttacmentCell
        
        let attachment = arrayOfAttachments[indexPath.row]
        if attachment.attachmentName?.last == "f"{
            cell.fileNameLbl.text = "\(PisiffikStrings.document()).pdf"
            cell.fileImageView.image = R.image.file_icon()
        }else{
            cell.fileNameLbl.text = "\(PisiffikStrings.photo()) (\(indexPath.row + 1)).png"
            cell.fileImageView.image = R.image.image_icon()
        }
        cell.fileSizeLbl.isHidden = true
        cell.cancelBtn.isHidden = true
        
        return cell
    }
    
}


extension AttacmentsVC: LightboxControllerPageDelegate,LightboxControllerDismissalDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
     
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
}
