//
//  OfferNewspaperDetailVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import FSPagerView
import WebKit

class OfferNewspaperDetailVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var downloadBtn: LoadingButton!
    
    @IBOutlet weak var newspaperPagerView: FSPagerView!{
        didSet{
            newspaperPagerView.delegate = self
            newspaperPagerView.dataSource = self
            newspaperPagerView.register(UINib(nibName: .offerItemsPagerCell, bundle: nil), forCellWithReuseIdentifier: .offerItemsPagerCell)
        }
    }
    @IBOutlet weak var firstIndexBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageNmbLbl: UILabel!
    @IBOutlet weak var lastIndexBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    
    //MARK: - PROPERTIES -
    
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
    
    var webStr : String = ""
    
    let newsPaperImages = [
        R.image.newspaper_1(),
        R.image.newspaper_2(),
        R.image.newspaper_3(),
        R.image.newspaper_4(),
        R.image.newspaper_1(),
        R.image.newspaper_2(),
        R.image.newspaper_3(),
        R.image.newspaper_4()
    ]
    
    var currentIndex : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
//        setUpPagerViewProperties()
        self.backView.addSubview(webView)
        self.webView.navigationDelegate = self
        self.downloadBtn.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.backView.bounds
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        self.setWebURL()
        cancelBtn.setTitle(PisiffikStrings.cancel(), for: .normal)
//        self.pageNmbLbl.text = "\(self.currentIndex + 1) - \(newsPaperImages.count)"
    }
    
    func setUI() {
        cancelBtn.titleLabel?.font = Fonts.mediumFontsSize16
        cancelBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        pageNmbLbl.font = Fonts.semiBoldFontsSize16
        pageNmbLbl.textColor = R.color.textBlackColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setUpPagerViewProperties(){
        newspaperPagerView.automaticSlidingInterval = 0.0
        newspaperPagerView.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    private func scrollCollectionViews(at index: Int){
        self.currentIndex = index
        self.pageNmbLbl.text = "\(self.currentIndex + 1) - \(newsPaperImages.count)"
        self.newspaperPagerView.scrollToItem(at: self.currentIndex, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapCancelBtn(_ sender: UIButton){
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapDownloadBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapFirstIndexBtn(_ sender: UIButton){
        sender.showAnimation {
            self.scrollCollectionViews(at: 0)
        }
    }
    
    @IBAction func didTapPreviousBtn(_ sender: UIButton){
        sender.showAnimation {
            if self.currentIndex != 0{
                self.scrollCollectionViews(at: self.currentIndex - 1)
            }
        }
    }
    
    @IBAction func didTapNextBtn(_ sender: UIButton){
        sender.showAnimation {
            if self.currentIndex != (self.newsPaperImages.count - 1){
                self.scrollCollectionViews(at: self.currentIndex + 1)
            }
        }
    }
    
    @IBAction func didTapLastIndexBtn(_ sender: UIButton){
        sender.showAnimation {
            if self.currentIndex != (self.newsPaperImages.count - 1){
                self.scrollCollectionViews(at: self.newsPaperImages.count - 1)
            }
        }
    }
    
}


//MARK: - FSPAGER COLLECTION VIEW METODS -

extension OfferNewspaperDetailVC: FSPagerViewMethods{
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return newsPaperImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        return configureNewsCell(at: index)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        Constants.printLogs("\(index)")
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.currentIndex = targetIndex
        self.pageNmbLbl.text = "\(self.currentIndex + 1) - \(newsPaperImages.count)"
    }
    
}

//MARK: - EXTENSION FOR FSPAGER CELL -

extension OfferNewspaperDetailVC{
    
    fileprivate func configureNewsCell(at index: Int) -> FSPagerViewCell{
        let cell = newspaperPagerView.dequeueReusableCell(withReuseIdentifier: .offerItemsPagerCell, at: index) as! OfferItemsPagerCell
        cell.itemImageView.contentMode = .scaleAspectFill
        cell.itemImageView.image = self.newsPaperImages[index]
        return cell
    }
    
}


//MARK: - EXTENSION FOR WKWEBVIEW DELEGATES -

extension OfferNewspaperDetailVC: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Constants.printLogs("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.downloadBtn.hideLoading()
        self.downloadBtn.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Constants.printLogs("didFailToFinish")
    }
    
}


//MARK: - EXTENSION FOR SET TEXT -

extension OfferNewspaperDetailVC{
    
    private func setWebURL(){
        self.downloadBtn.showLoading()
        guard let url = URL(string: self.webStr) else {return}
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
}
