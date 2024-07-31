//
//  OfferConceptCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class OfferConceptCell: UITableViewCell {

    @IBOutlet weak var conceptLbl: UILabel!{
        didSet{
            conceptLbl.font = Fonts.mediumFontsSize18
            conceptLbl.textColor = R.color.textBlackColor()
            conceptLbl.text = PisiffikStrings.concept()
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
            seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
        }
    }
    @IBOutlet weak var conceptCollectionView: UICollectionView!{
        didSet{
            conceptCollectionView.delegate = self
            conceptCollectionView.dataSource = self
            conceptCollectionView.register(R.nib.offerTabsTopCell)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: -  EXTENSION FOR COLLECTION VIEW METODS -

extension OfferConceptCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conceptImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureConceptCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedIndex = indexPath.row
        self.conceptCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.conceptCollectionView.frame.size
        return CGSize(width: 100.0, height: size.height)
    }
    
}

//MARK: - EXTENSION FOR CONCEPT CELL -

extension OfferConceptCell{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.conceptCollectionView.dequeueReusableCell(withReuseIdentifier: .offerTabsTopCell, for: indexPath) as! OfferTabsTopCell
        
        cell.nameLbl.isHidden = true
        cell.offerImageView.isHidden = false
        cell.offerImageView.image = self.conceptImages[indexPath.row]
        
        if indexPath.row == self.currentSelectedIndex{
            cell.backView.layer.borderWidth = 1
        }else{
            cell.backView.layer.borderWidth = 0
        }
        
        return cell
    }
    
}


