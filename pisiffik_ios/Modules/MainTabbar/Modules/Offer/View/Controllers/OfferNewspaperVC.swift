//
//  OfferNewspaperVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class OfferNewspaperVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newspaperCollectionView: UICollectionView!{
        didSet{
            newspaperCollectionView.delegate = self
            newspaperCollectionView.dataSource = self
            newspaperCollectionView.register(R.nib.offerNewspaperSubCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var viewModel = AllDigitalNewpapersViewModel()
    private var isLoading: Bool = false
    private var newspapers : [DigitalNewspaper] = []
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getNewspapers()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.offerNewspapers()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getNewspapers(){
        if Network.isAvailable{
            self.isLoading = true
            self.viewModel.getAllDigitalNewspapers()
        }else{
            AlertController.showAlert(title: PisiffikStrings.alert(), message: PisiffikStrings.oopsNoInternetConnection(), inVC: self)
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

//MARK: - EXTENSION FOR AllDigitalNewpapersViewModel DELEGATES -

extension OfferNewspaperVC: AllDigitalNewpapersViewModelDelegate{
    
    func didReceiveAllDigitalNewpapers(response: NewspaperResponse) {
        isLoading = false
        if let newspapers = response.data?.newspapers{
            self.newspapers = newspapers
        }
        DispatchQueue.main.async { [weak self] in
            self?.newspaperCollectionView.reloadData()
        }
    }
    
    func didReceiveAllDigitalNewpapersResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.newspaperCollectionView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        if type == APIType.homeAPI{
            self.newspaperCollectionView.reloadData()
            self.newspaperCollectionView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.viewModel.getAllDigitalNewspapers()
            }
        }
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension OfferNewspaperVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading{
            return 10
        }else{
            return self.newspapers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureNewsPaperCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        guard let webStr = self.newspapers[indexPath.row].webLink else {return}
        guard let newsPaperDetailVC = R.storyboard.offerSB.offerNewspaperDetailVC() else {return}
        newsPaperDetailVC.webStr = webStr
        self.present(newsPaperDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.newspaperCollectionView.frame.size
        return CGSize(width: ((size.width - 10) / 2), height: 240.0)
    }
    
}

//MARK: - EXTENSION FOR NEWSPAPER CELL -

extension OfferNewspaperVC{
    
    private func configureNewsPaperCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = newspaperCollectionView.dequeueReusableCell(withReuseIdentifier: .offerNewspaperSubCell, for: indexPath) as! OfferNewspaperSubCell
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            let newspaper = self.newspapers[indexPath.row]
            if let newspaperURL = URL(string: newspaper.coverImage ?? ""){
                cell.newsPaperImage.kf.indicatorType = .activity
                cell.newsPaperImage.kf.setImage(with: newspaperURL)
            }
            cell.dateLbl.text = "\(newspaper.startDate ?? "") - \(newspaper.endDate ?? "")"
        }
        return cell
    }
    
}
