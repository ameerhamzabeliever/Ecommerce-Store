//
//  CountryVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

enum CountryMode{
    case country
    case state
    case city
}

protocol CountrySelectionDelegates{
    func didSelectCountry(name: String,id: Int)
}

class CountryVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var countryTableView: UITableView!{
        didSet{
            countryTableView.delegate = self
            countryTableView.dataSource = self
            countryTableView.register(R.nib.countryCell)
        }
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var mode : CountryMode = {
        let mode : CountryMode = .country
        return mode
    }()
    
    var delegate: CountrySelectionDelegates?
    
    var arrayOfCountries : [CountryResponseData] = []
    var arrayOfState: [StateResponseData] = []
    var arrayOfCity: [CityResponseData] = []
    
    var currentID : Int = 0
    
    var countryViewModel : CountryViewModel = CountryViewModel()
    var stateViewModel : StateViewModel = StateViewModel()
    var cityViewModel : CityViewModel = CityViewModel()
    
    var isLoading : Bool = false{
        didSet{
            countryTableView.reloadData()
        }
    }
    
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
        setupViewModel()
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
       
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setupViewModel(){
        self.isLoading = true
        switch mode {
        case .country:
            self.countryViewModel.delegate = self
            self.countryViewModel.getCounties()
        case .state:
            self.stateViewModel.delegate = self
            self.stateViewModel.getStatesBy(id: self.currentID)
        case .city:
            self.cityViewModel.delegate = self
            self.cityViewModel.getCityBy(id: self.currentID)
        }
    }
    
    //MARK: - ACTIONS -
    
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR VIEW MODEL DELEGATES -

extension CountryVC: CountryViewModelDelegates{
    
    func didReceive(response: CountryResponse) {
        self.isLoading = false
        if let countries = response.data{
            self.arrayOfCountries = countries
            DispatchQueue.main.async { [weak self] in
                self?.countryTableView.reloadData()
            }
        }
    }
    
    func didReceiveCountryResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

extension CountryVC: StateViewModelDelegates{
    
    func didReceive(response: StateResponse) {
        self.isLoading = false
        if let states = response.data{
            self.arrayOfState = states
            DispatchQueue.main.async { [weak self] in
                self?.countryTableView.reloadData()
            }
        }
    }
    
    func didReceiveStateResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

extension CountryVC: CityViewModelDelegates{
    
    func didReceive(response: CityResponse) {
        self.isLoading = false
        if let city = response.data{
            self.arrayOfCity = city
            DispatchQueue.main.async { [weak self] in
                self?.countryTableView.reloadData()
            }
        }
    }
    
    func didReceiveCityResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}



//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension CountryVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 50 : numberOfRowsInSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading {
            return
        }
        self.didSelectCellAt(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - EXTENSION FOR FILTER CELLS -

extension CountryVC{
    
    private func numberOfRowsInSections() -> Int{
        switch mode {
        case .country:
            return self.arrayOfCountries.count
        case .state:
            return self.arrayOfState.count
        case .city:
            return self.arrayOfCity.count
        }
    }
    
    private func configureCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = countryTableView.dequeueReusableCell(withIdentifier: .countryCell, for: indexPath) as! CountryCell
        
        if isLoading{
            
            cell.showLoadingView()
            
        }else{
            
            switch mode {
            case .country:
                if let countryName = self.arrayOfCountries[indexPath.row].name{
                    cell.nameLbl.text = countryName
                    cell.hideLoadingView()
                }
            case .state:
                if let stateName = self.arrayOfState[indexPath.row].name{
                    cell.nameLbl.text = stateName
                    cell.hideLoadingView()
                }
            case .city:
                if let cityName = self.arrayOfCity[indexPath.row].name{
                    cell.nameLbl.text = cityName
                    cell.hideLoadingView()
                }
            }
        }
        
        return cell
    }
    
    private func didSelectCellAt(indexPath: IndexPath){
        switch mode {
        case .country:
            let country = self.arrayOfCountries[indexPath.row]
            if let countryName = country.name, let countryID = country.id{
                self.delegate?.didSelectCountry(name: countryName, id: countryID)
            }
        case .state:
            let state = self.arrayOfState[indexPath.row]
            if let stateName = state.name, let stateID = state.id{
                self.delegate?.didSelectCountry(name: stateName, id: stateID)
            }
        case .city:
            let city = self.arrayOfCity[indexPath.row]
            if let cityName = city.name, let cityID = city.id{
                self.delegate?.didSelectCountry(name: cityName, id: cityID)
            }
        }
    }
    
    
}
