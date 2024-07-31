//
//  FeedbackDoneVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class FeedbackDoneVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToViewController(of: ContactUsVC.self, animated: false)
        }
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.thankYouForContactingUs()
        descriptionLbl.text = PisiffikStrings.pisiffikRepresentativeWillRespondToYourQuerySoon()
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = .white
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    
    
}
