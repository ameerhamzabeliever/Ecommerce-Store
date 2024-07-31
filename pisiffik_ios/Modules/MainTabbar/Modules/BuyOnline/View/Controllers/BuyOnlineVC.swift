//
//  BuyOnlineVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SYBadgeButton

class BuyOnlineVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cartBtn: SYBadgeButton!
    @IBOutlet weak var itemsCollectionView: UICollectionView!{
        didSet{
            itemsCollectionView.delegate = self
            itemsCollectionView.dataSource = self
//            itemsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            itemsCollectionView.register(R.nib.favoritesListCell)
            itemsCollectionView.register(R.nib.favoritesGridCell)
            itemsCollectionView.register(R.nib.buyOnlineHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        }
    }
    
    //MARK: - PROPERTIES -
    
    var listDirection : MyListDirection = {
        let mode : MyListDirection = .grid
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
//        self.cartBtn.badgeValue = "2"
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.online()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func navigateToProductDetailVC(){
        guard let productDetailVC = R.storyboard.homeSB.productDetailVC() else {return}
        self.push(controller: productDetailVC, hideBar: true, animated: true)
    }
    
    private func navigateToCartVC() {
        guard let cartVC = R.storyboard.homeSB.myCartVC() else {return}
        self.push(controller: cartVC, hideBar: true, animated: true)
    }
    
    private func navigateToPreferenceVC() {
        guard let prefVC = R.storyboard.preferencesSB.preferenceVC() else { return }
        self.push(controller: prefVC, hideBar: true, animated: true)
    }
    
    //MARK: - ACTIONS -
    
    @objc func didTapFilterBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigateToPreferenceVC()
        }
    }
    
    @objc func didSearchingList(_ textField: UITextField){
        
    }
    
    @IBAction func didTapCartBtn(_ sender: SYBadgeButton){
        sender.showAnimation {
            self.navigateToCartVC()
        }
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension BuyOnlineVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listDirection{
        case .grid:
            return configureGridCell(indexPath)
        case .list:
            return configureListCell(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigateToProductDetailVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.itemsCollectionView.frame.width - 10)
        switch listDirection{
        case .grid:
            if UIDevice().userInterfaceIdiom == .phone{
                return CGSize(width: width / 2, height: 245.0)
            }else{
                return CGSize(width: width / 3, height: 275.0)
            }
        case .list:
            return CGSize(width: (width), height: 145.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return configureItemsHeader(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.itemsCollectionView.frame.size.width
        return CGSize(width: width, height: 140.0)
    }
    
}

//MARK: - EXTENSION FOR ITEM CELLS -

extension BuyOnlineVC{
    
    fileprivate func configureListCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesListCell, for: indexPath) as! FavoritesListCell
        
        cell.itemImageView.image = R.image.ic_led()
        cell.discountedPriceLbl.attributedText = "24.99 kr.".strikeThrough()
        
        cell.favoriteBtn.addTapGestureRecognizer {
            if cell.favoriteBtn.isSelected == true {
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
        }
        cell.cartBtn.addTapGestureRecognizer {
            if cell.cartBtn.isSelected == true {
                cell.cartBtn.isSelected = false
            }else{
                cell.cartBtn.isSelected = true
            }
        }
        return cell
    }
    
    fileprivate func configureGridCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesGridCell, for: indexPath) as! FavoritesGridCell
        
        cell.itemImageView.image = R.image.ic_led()
        cell.discountPrice.attributedText = "24.99 kr.".strikeThrough()
        
        cell.favoriteBtn.addTapGestureRecognizer {
            if cell.favoriteBtn.isSelected == true {
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
        }
        cell.cartListBtn.addTapGestureRecognizer {
            if cell.cartListBtn.isSelected == true {
                cell.cartListBtn.isSelected = false
            }else{
                cell.cartListBtn.isSelected = true
            }
        }
        
        if UIDevice().userInterfaceIdiom == .phone{
            cell.imageHeightConstrain.constant = 69.5
            cell.itemImageView.contentMode = .scaleAspectFill
        }else{
            cell.imageHeightConstrain.constant = 94.5
            cell.itemImageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
}

//MARK: - EXTENSION FOR COLLECTION HEADER VIEW -

extension BuyOnlineVC{
    
    fileprivate func configureItemsHeader(_ indexPath: IndexPath) -> UICollectionReusableView{
        let header = itemsCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .buyOnlineHeaderView, for: indexPath) as! BuyOnlineHeaderView
        
        header.setItems(count: 14)
        header.searchTextField.addTarget(self, action: #selector(didSearchingList(_:)), for: .editingChanged)
        header.filterBtn.addTarget(self, action: #selector(didTapFilterBtn(_:)), for: .touchUpInside)
        
        header.gridBtn.addTapGestureRecognizer { [weak self] in
            header.gridBtn.isSelected = true
            header.listBtn.isSelected = false
            self?.listDirection = .grid
            self?.itemsCollectionView.reloadData()
        }
        
        header.listBtn.addTapGestureRecognizer { [weak self] in
            header.gridBtn.isSelected = false
            header.listBtn.isSelected = true
            self?.listDirection = .list
            self?.itemsCollectionView.reloadData()
        }
    
        return header
    }
    
}
