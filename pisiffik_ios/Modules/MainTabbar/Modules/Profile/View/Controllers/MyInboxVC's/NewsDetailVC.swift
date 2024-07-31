//
//  NewsDetailVC.swift
//  pisiffik_ios
//
//  Created by APPLE on 7/1/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class NewsDetailVC: BaseVC {
    
    //MARK: - OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsDetailLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    var newsObj : NewsList = NewsList()
    
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
        UserDefault.shared.saveNewsDetailVC(open: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefault.shared.saveNewsDetailVC(open: false)
    }
    
    //MARK: - METHODS -
    @objc func setText(){
        titleLbl.text = PisiffikStrings.news()
        newsTitleLbl.text = self.newsObj.title
        dateLbl.text = self.newsObj.updated_at
        newsDetailLbl.text = self.newsObj.description
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        newsTitleLbl.font = Fonts.mediumFontsSize16
        newsTitleLbl.textColor = R.color.textLightBlackColor()
        dateLbl.font = Fonts.mediumFontsSize12
        dateLbl.textColor = R.color.textLightGrayColor()
        newsDetailLbl.font = Fonts.mediumFontsSize12
        newsDetailLbl.textColor = R.color.textGrayColor()
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
