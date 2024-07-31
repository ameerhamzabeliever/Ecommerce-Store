//
//  PrivacyVC.swift
//  pisiffik_ios
//
//  Created by APPLE on 7/1/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import WebKit

enum PrivacyType{
    case about
    case termsOfUse
    case privacy
}

class PrivacyVC: BaseVC {
    
    //MARK: - OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var loadingBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    var mode : PrivacyType = {
        let mode : PrivacyType = .about
        return mode
    }()
    
    private let webView : WKWebView = {
        let preferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            preferences.allowsContentJavaScript = true
        }
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    private let termOfUseLink : String = "https://www.pisiffik.gl/da/content/11-handelsbetingelser?content_only=1"
    private let privacyLink : String = "https://www.pisiffik.gl/da/content/11-handelsbetingelser?content_only=1"
    private let aboutPisiffikLink : String = "https://www.pisiffik.gl/da/content/47-organisationen?content_only=1"
    
    //MARK: - LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.backView.addSubview(webView)
        self.webView.navigationDelegate = self
        self.loadingBtn.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.backView.bounds
    }
    
    //MARK: - METHODS -
    @objc func setText(){
        if mode == .about{
            titleLbl.text = PisiffikStrings.aboutPisiffik()
            setTextBaseOn(type: .about)
        }else if mode == .termsOfUse{
            titleLbl.text = PisiffikStrings.termsAndConditions()
            setTextBaseOn(type: .termsOfUse)
        }else{
            titleLbl.text = PisiffikStrings.privacyPolicy()
            setTextBaseOn(type: .privacy)
        }
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR WKWEBVIEW DELEGATES -

extension PrivacyVC: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Constants.printLogs("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingBtn.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Constants.printLogs("didFailToFinish")
    }
    
}

//MARK: - EXTENSION FOR SET TEXT -

extension PrivacyVC{
    
    private func setTextBaseOn(type: PrivacyType){
        self.loadingBtn.showLoading()
        switch type {
        case .about:
            guard let url = URL(string: self.aboutPisiffikLink) else {return}
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        case .termsOfUse:
            guard let url = URL(string: self.termOfUseLink) else {return}
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        case .privacy:
            guard let url = URL(string: self.privacyLink) else {return}
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        }
    }
    
}
