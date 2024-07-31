//
//  MembershipHeaderView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class MembershipHeaderView: UICollectionReusableView {

    @IBOutlet weak var membershipView: UIView!
    @IBOutlet weak var premiumLbl: UILabel!{
        didSet{
            premiumLbl.font = Fonts.mediumFontsSize32
            premiumLbl.textColor = .white
        }
    }
    @IBOutlet weak var membershipLbl: UILabel!{
        didSet{
            membershipLbl.font = Fonts.mediumFontsSize14
            membershipLbl.textColor = .white
            membershipLbl.text = PisiffikStrings.membership()
        }
    }
    @IBOutlet weak var membershipCollectionView: UICollectionView!{
        didSet{
            membershipCollectionView.delegate = self
            membershipCollectionView.dataSource = self
            membershipCollectionView.register(R.nib.offerTabsTopCell)
        }
    }
    @IBOutlet weak var membershipOffersLbl: ActiveLabel!{
        didSet{
            membershipOffersLbl.font = Fonts.mediumFontsSize14
            membershipOffersLbl.textColor = R.color.lightBlueColor()
        }
    }
    @IBOutlet weak var gridBtn: UIButton!{
        didSet{
            gridBtn.tintColor = .clear
            gridBtn.setImage(R.image.ic_unselect_grid_icon(), for: .normal)
            gridBtn.setImage(R.image.ic_select_grid_icon(), for: .selected)
            gridBtn.isSelected = true
        }
    }
    @IBOutlet weak var listBtn: UIButton!{
        didSet{
            listBtn.tintColor = .clear
            listBtn.setImage(R.image.ic_unselect_list_icon(), for: .normal)
            listBtn.setImage(R.image.ic_select_list_icon(), for: .selected)
            listBtn.isSelected = false
        }
    }
    
    
    var currentSelectedIndex : Int = 0
    
    let conceptImages = [
        R.image.ic_prefrence_pisiffik(),
        R.image.ic_prefrence_torrak(),
        R.image.ic_prefrence_elgiganten(),
        R.image.ic_prefrence_jysk(),
        R.image.ic_prefrence_thansen(),
        R.image.ic_prefrence_ilva()
    ]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension MembershipHeaderView: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.conceptImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureConceptCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedIndex = indexPath.row
        self.membershipCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.membershipCollectionView.frame.size
        return CGSize(width: 120.0, height: size.height)
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW CELLS METHOD -

extension MembershipHeaderView{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.membershipCollectionView.dequeueReusableCell(withReuseIdentifier: .offerTabsTopCell, for: indexPath) as! OfferTabsTopCell
        
        if indexPath.row == 0{
            cell.nameLbl.isHidden = false
            cell.offerImageView.isHidden = true
        }else{
            cell.nameLbl.isHidden = true
            cell.offerImageView.isHidden = false
            cell.offerImageView.image = self.conceptImages[indexPath.row - 1]
        }
        
        if indexPath.row == self.currentSelectedIndex{
            cell.backView.layer.borderWidth = 1
        }else{
            cell.backView.layer.borderWidth = 0
        }
        
        return cell
    }
    
}
