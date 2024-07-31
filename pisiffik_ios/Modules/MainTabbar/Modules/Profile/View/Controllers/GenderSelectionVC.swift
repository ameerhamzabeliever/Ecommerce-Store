//
//  GenderSelectionVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol GenderSelectionProtocol{
    func didSelectGenderOf(type: String,id: Int)
}

class GenderSelectionVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var sheetTableView: ContentSizedTableView!{
        didSet{
            sheetTableView.delegate = self
            sheetTableView.dataSource = self
            sheetTableView.register(R.nib.genderCell)
        }
    }
    @IBOutlet weak var backView: UIView!
    
    //MARK: - PROPERTIES -
    
    var delegate: GenderSelectionProtocol?
    let genders : [String] = [PisiffikStrings.male(), PisiffikStrings.female(), PisiffikStrings.other()]
    
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
    
    
}

//MARK: - EXTENSION FOR TABLE VIEW DELEGATES -

extension GenderSelectionVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sheetTableView.dequeueReusableCell(withIdentifier: .genderCell, for: indexPath) as! GenderCell
        
        cell.genderLbl.text = genders[indexPath.row]
    
        if indexPath.row == (genders.count - 1){
            cell.seperator.isHidden = true
        }else{
            cell.seperator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectGenderOf(type: genders[indexPath.row], id: (indexPath.row + 1))
        self.dismiss(animated: true, completion: nil)
    }
    
}
