//
//  PDFViewVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import PDFKit

enum PDFViewMode{
    case local
    case url
}

class PDFViewVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    //MARK: - PROPERTIES -
    
    var pdfData: Data = Data()
    var pdfURL : String = ""
    var pdfView : PDFView?
    
    var mode : PDFViewMode = {
        let mode : PDFViewMode = .local
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        if mode == .local{
            showPDFViewWithData()
        }else{
            showPDFViewWithURL()
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        cancelBtn.setTitle(PisiffikStrings.cancel(), for: .normal)
    }
    
    func setUI() {
        cancelBtn.titleLabel?.font = Fonts.mediumFontsSize16
        cancelBtn.setTitleColor(.white, for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func showPDFViewWithData(){
        pdfView = PDFView(frame: self.view.bounds)
        self.bgView.addSubview(pdfView ?? PDFView())
        if let pdfDocument = PDFDocument(data: self.pdfData) {
            pdfView?.displayMode = .singlePageContinuous
            pdfView?.autoScales = true
            pdfView?.displayDirection = .vertical
            pdfView?.document = pdfDocument
        }
    }
    
    private func showPDFViewWithURL(){
        pdfView = PDFView(frame: self.view.bounds)
        self.bgView.addSubview(pdfView ?? PDFView())
        if let url = URL(string: self.pdfURL){
            if let pdfDocument = PDFDocument(url: url) {
                pdfView?.displayMode = .singlePageContinuous
                pdfView?.autoScales = true
                pdfView?.displayDirection = .vertical
                pdfView?.document = pdfDocument
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapCancelBtn(_ sender: UIButton){
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
