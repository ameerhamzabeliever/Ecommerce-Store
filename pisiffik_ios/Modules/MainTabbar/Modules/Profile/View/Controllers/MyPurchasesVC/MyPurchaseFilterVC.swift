//
//  MyPurchaseFilterVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol MyPurchasesFilterProtocol{
    func didSelectCurrent(filter: String)
}

class MyPurchaseFilterVC: BaseVC {
    
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
    
    private var arrayOfFilters: [String] = MyPurchaseViewModel().getFilters()
    var delegate: MyPurchasesFilterProtocol?
    
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

extension MyPurchaseFilterVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureItemTypeCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectCurrent(filter: self.arrayOfFilters[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - EXTENSION FOR FILTER CELLS -

extension MyPurchaseFilterVC{
    
    private func configureItemTypeCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = filterTableView.dequeueReusableCell(withIdentifier: .genderCell, for: indexPath) as! GenderCell
        
        cell.genderImage.isHidden = true
        cell.genderLbl.text = self.arrayOfFilters[indexPath.row]
        if indexPath.row == (self.arrayOfFilters.count - 1){
            cell.seperator.isHidden = true
        }else{
            cell.seperator.isHidden = false
        }
        
        return cell
    }
    
}
