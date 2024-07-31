//
//  SearchLocationVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    
    //MARK: - PROPERTIES -
    
    private var placesClient: GMSPlacesClient!
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        placesClient = GMSPlacesClient.shared()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Current place error: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let place = placeLikelihoods?.first?.place else {
                strongSelf.nameLabel.text = "No current place"
                strongSelf.addressLabel.text = ""
                return
            }
            
            strongSelf.nameLabel.text = place.name
            strongSelf.addressLabel.text = place.formattedAddress
        }
    }
    
    
}
      
