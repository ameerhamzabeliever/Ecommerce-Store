//
//  StoreQRCodeVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class StoreQRCodeVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var membershipCardBtn: UIButton!
    
    @IBOutlet weak var scanView: QRCodeReaderView! {
      didSet {
          scanView.setupComponents(with: QRCodeReaderViewControllerBuilder {
          $0.reader                 = reader
          $0.showTorchButton        = false
          $0.showSwitchCameraButton = false
          $0.showCancelButton       = false
          $0.showOverlayView        = true
          $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        })
      }
    }
    
    //MARK: - PROPERTIES -
    
    lazy var reader: QRCodeReader = QRCodeReader()
    
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
//        reader.startScanning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) { [weak self] in
            self?.scanInPreview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reader.stopScanning()
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.scanBarcode()
        membershipCardBtn.setTitle(PisiffikStrings.myMembershipCard(), for: .normal)
        helpBtn.setTitle(PisiffikStrings.getHelpWithScan(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = .white
        membershipCardBtn.titleLabel?.font = Fonts.mediumFontsSize16
        membershipCardBtn.setTitleColor(.white, for: .normal)
        helpBtn.titleLabel?.font = Fonts.mediumFontsSize14
        helpBtn.setTitleColor(.white, for: .normal)
        helpBtn.underline()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    private func scanInPreview(){
        guard checkScanPermissions(), !reader.isRunning else { return }
        reader.didFindCode = { result in
            AlertController.showAlert(title: "QRCodeReader", message: result.value, inVC: self) { [weak self] in
                guard let self = self else {return}
                print("Completion with result: \(result.value) of type \(result.metadataType)")
                self.reader.startScanning()
            }
        }
        reader.startScanning()
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
            guard let membershipCardVC = R.storyboard.storeSB.myMembershipCardVC() else {return}
            self.present(membershipCardVC, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR PERMISSION ALLERT -

extension StoreQRCodeVC{
    
    private func checkScanPermissions() -> Bool {
      do {
        return try QRCodeReader.supportsMetadataObjectTypes()
      } catch let error as NSError {
        let alert: UIAlertController

        switch error.code {
        case -11852:
            alert = UIAlertController(title: PisiffikStrings.error(), message: "thisAppIsNotAuthorizedToUseBackCamera", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "setting", style: .default, handler: { (_) in
            DispatchQueue.main.async {
              if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(settingsURL)
              }
            }
          }))

            alert.addAction(UIAlertAction(title: PisiffikStrings.cancel(), style: .cancel, handler: nil))
        default:
            alert = UIAlertController(title: PisiffikStrings.error(), message: "readerNotSupportedByTheCurrentDevice", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: PisiffikStrings.ok(), style: .cancel, handler: nil))
        }

        present(alert, animated: true, completion: nil)

        return false
      }
    }
    
}
