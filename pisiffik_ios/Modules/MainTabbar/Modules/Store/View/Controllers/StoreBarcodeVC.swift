//
//  StoreBarcodeVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import AVKit

class StoreBarcodeVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var membershipCardBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private var scanViewModel = ScanProductViewModel()
    private var generateBarcodeViewModel = GenerateBarcodeViewModel()
    private var isLoading: Bool = false
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        scanViewModel.delegate = self
        generateBarcodeViewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermission()
        if (captureSession?.isRunning == false) {
            DispatchQueue.global().async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
            DispatchQueue.main.async { [weak self] in
                self?.captureSession = nil
            }
        }
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.scanBarcode()
        membershipCardBtn.setTitle(PisiffikStrings.myMembershipCard(), for: .normal)
        helpBtn.titleLabel?.text = PisiffikStrings.getHelpWithScan()
        helpBtn.underline()
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = .white
        membershipCardBtn.titleLabel?.font = Fonts.mediumFontsSize16
        membershipCardBtn.setTitleColor(.white, for: .normal)
        helpBtn.titleLabel?.font = Fonts.mediumFontsSize14
        helpBtn.setTitleColor(.white, for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }

    func failed() {
        self.showAlert(title: PisiffikStrings.scanningNotSupported(), errorMessages: [PisiffikStrings.yourDeviceDoesNotSupportScanningaCodeFromAnItemPleaseUseADeviceWithACamera()])
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

//        dismiss(animated: true)
    }

    func found(code: String) {
        if Network.isAvailable{
            if let barcode = code.parseToInt(){
                isLoading = true
                let request = ScanProductRequest(barcode: barcode)
                self.scanViewModel.getScanProductInfo(request: request)
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.oopsNoInternetConnection(), delegate: self)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.cameraPermissionNeeded(),cancelBtnHide: false,alertType: .CameraPermission, delegate: self)
        case .restricted:
            self.showAlert(title: PisiffikStrings.alert(), description: PisiffikStrings.cameraPermissionNeeded(),cancelBtnHide: false,alertType: .CameraPermission, delegate: self)
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.configureCaptureSession()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        self?.configureCaptureSession()
                    }
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    private func navigateToProductInfoVC(product: ScanProductInfo){
        guard let productInfoVC = R.storyboard.storeSB.productInfoVC() else {return}
        productInfoVC.delegate = self
        productInfoVC.name = product.name ?? ""
        productInfoVC.productDescription = product.description ?? ""
        if product.isDiscountEnabled == true{
            productInfoVC.price = "\(product.afterDiscountPrice ?? 0) \(product.currency ?? "")"
        }else{
            productInfoVC.price = "\(product.salePrice ?? 0) \(product.currency ?? "")"
        }
        self.present(productInfoVC, animated: true, completion: nil)
    }
    
    private func navigateToMemberShipCardVC(image: UIImage,cardNmb: String,loyalityNmb: String){
        guard let membershipCardVC = R.storyboard.storeSB.myMembershipCardVC() else {return}
        membershipCardVC.membershipCard = image
        membershipCardVC.cardNmb = cardNmb
        membershipCardVC.loyalityNmb = loyalityNmb
        membershipCardVC.delegate = self
        self.present(membershipCardVC, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapHelpBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let helpVC = R.storyboard.storeSB.storeHelpVC() else {return}
            self.present(helpVC, animated: true)
        }
    }
    
    @IBAction func didTapMembersipCardBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.isLoading && !self.membershipCardBtn.isAnimating{
                if Network.isAvailable{
                    self.membershipCardBtn.showLoading()
                    if self.captureSession?.isRunning == true{
                        self.captureSession.stopRunning()
                    }
                    self.generateBarcodeViewModel.generateBarcode()
                }else{
                    self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
        }
    }
    
}

//MARK: - EXTENSION FOR SCAN PRODUCT VIEW MODEL DELEGATES -

extension StoreBarcodeVC: ScanProductViewModelDelegate{
    
    func didReceiveScanProductInfo(response: ScanProductResponse) {
        self.isLoading = false
        if let productInfo = response.data?.product{
            self.dismiss(animated: false)
            self.navigateToProductInfoVC(product: productInfo)
        }
    }
    
    func didReceiveScanProductInfoResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), description: errorMessage?.first ?? "", delegate: self)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.generateBarcode{
            self.membershipCardBtn.hideLoading()
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
        }else{
            self.showAlert(title: PisiffikStrings.alert(), description: error?.first ?? "", delegate: self)
        }
    }
    
}

//MARK: - EXTENSION FOR GENERATE BARCODE VIEW MODEL DELEGATES -

extension StoreBarcodeVC: GenerateBarcodeViewModelDelegate{
    
    func didReceiveGenerateBarcode(response: GenerateBarcodeResponse) {
        isLoading = false
        self.membershipCardBtn.hideLoading()
        self.dismiss(animated: false)
        if let imageBase64String = response.data?.image{
            self.navigateToMemberShipCardVC(image: Utils.shared.convertBase64StringToImage(imageBase64String: imageBase64String), cardNmb: response.data?.cardNumber ?? "", loyalityNmb: response.data?.loyaltyId ?? "")
        }
    }
    
    func didReceiveGenerateBarcodeResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.membershipCardBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}


//MARK: - EXTENSION FOR CAPTURE SESSION -

extension StoreBarcodeVC: AVCaptureMetadataOutputObjectsDelegate{
    
    private func configureCaptureSession(){
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            if #available(iOS 15.4, *) {
                metadataOutput.metadataObjectTypes = [.code39, .code39Mod43, .ean13, .ean8, .code93, .code128, .pdf417, .aztec, .dataMatrix , .codabar, .gs1DataBar, .gs1DataBarExpanded, .gs1DataBarLimited, .microPDF417]
            } else {
                // Fallback on earlier versions
                metadataOutput.metadataObjectTypes = [.ean13, .ean8, .code93, .code128, .pdf417]
            }
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
    }
    
}


//MARK: - EXTENSION FOR PRODUCT INFO VC DELEGATES -

extension StoreBarcodeVC: ProductInfoDelegates, StoreHelpVCDelegates, MyMembershipCardDelegates{
    
    func didStartRunningCaptureSession() {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        if alertType == .CameraPermission{
            Utils.shared.goToAndEnableCameraPermission()
        }else{
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
    }
    
    func didUpdateCaptureSession() {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
}
