//
//  MyPointsFilterVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

enum MyPointsFilterMode{
    case filterByPointsType
    case filterByPointsDuration
}

protocol MyPointsFilterProtocol{
    func didSelectCurrentPoints(type: String,of filterType: MyPointsFilterMode)
}

class MyPointsFilterVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var filterTableView: ContentSizedTableView!{
        didSet{
            filterTableView.delegate = self
            filterTableView.dataSource = self
            filterTableView.register(R.nib.genderCell)
        }
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var mode : MyPointsFilterMode = {
        let mode : MyPointsFilterMode = .filterByPointsType
        return mode
    }()
    
    var delegate: MyPointsFilterProtocol?
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
       
    }
    
    func setUI() {
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension MyPointsFilterVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .filterByPointsType{
            return MyPointsEarnedType.allCases.count
        }else{
            return MyPointsDurationType.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mode == .filterByPointsType{
            return configurePointsTypeCell(indexPath)
        }else{
            return configurePointsDurationCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .filterByPointsType{
            self.delegate?.didSelectCurrentPoints(type: MyPointsEarnedType.allCases[indexPath.row].rawValue, of: self.mode)
        }else{
            self.delegate?.didSelectCurrentPoints(type: MyPointsDurationType.allCases[indexPath.row].rawValue, of: self.mode)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - EXTENSION FOR FILTER CELLS -

extension MyPointsFilterVC{
    
    fileprivate func configurePointsTypeCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = filterTableView.dequeueReusableCell(withIdentifier: .genderCell, for: indexPath) as! GenderCell
        
        cell.genderImage.isHidden = true
        cell.genderLbl.text = MyPointsEarnedType.allCases[indexPath.row].rawValue
        if indexPath.row == (MyPointsEarnedType.allCases.count - 1){
            cell.seperator.isHidden = true
        }else{
            cell.seperator.isHidden = false
        }
        
        return cell
    }
    
    fileprivate func configurePointsDurationCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = filterTableView.dequeueReusableCell(withIdentifier: .genderCell, for: indexPath) as! GenderCell
        
        cell.genderImage.isHidden = true
        cell.genderLbl.text = MyPointsDurationType.allCases[indexPath.row].rawValue
        if indexPath.row == (MyPointsDurationType.allCases.count - 1){
            cell.seperator.isHidden = true
        }else{
            cell.seperator.isHidden = false
        }
        
        return cell
    }
    
}
