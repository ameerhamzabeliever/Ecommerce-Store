//
//  OfferBannerCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class OfferBannerCell: UITableViewCell {

    @IBOutlet weak var conceptLbl: UILabel!{
        didSet{
            conceptLbl.font = Fonts.mediumFontsSize18
            conceptLbl.textColor = R.color.textBlackColor()
            conceptLbl.text = PisiffikStrings.concept()
            conceptLbl.isSkeletonable = true
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
    @IBOutlet weak var bannerImageView: UIImageView!{
        didSet{
            bannerImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var bannerHeightConstrain: NSLayoutConstraint!{
        didSet{
            if UIDevice().userInterfaceIdiom == .pad{
                bannerHeightConstrain.constant = 690.0
            }else{
//                bannerHeightConstrain.constant = 260.0
                bannerHeightConstrain.constant = 320.0
            }
        }
    }
    
    var isLoading: Bool = false{
        didSet{
            self.setBannerImageView()
            self.conceptCollectionView.reloadData()
        }
    }
    var selectedConceptID : Int = 2
    var mediaURL: String = ""
    var arrayOfConcept: [AllOffersConcepts] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        conceptLbl.showAnimatedGradientSkeleton()
        bannerImageView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        conceptLbl.hideSkeleton()
        bannerImageView.hideSkeleton()
    }
    
    private func setBannerImageView(){
        if let index = self.arrayOfConcept.firstIndex(where: {$0.id == self.selectedConceptID}){
            if let imageURL = URL(string: "\(self.mediaURL)\(self.arrayOfConcept[index].bannerImage ?? "")"){
                self.bannerImageView.kf.indicatorType = .activity
                self.bannerImageView.kf.setImage(with: imageURL)
            }
        }
    }
    
}


//MARK: -  EXTENSION FOR COLLECTION VIEW METODS -

extension OfferBannerCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isLoading ? 10 : arrayOfConcept.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureConceptCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        if let index = self.arrayOfConcept.firstIndex(where: {$0.id == self.selectedConceptID}){
            if index == indexPath.row {return}
            self.selectedConceptID = self.arrayOfConcept[indexPath.row].id ?? 0
            self.setBannerImageView()
            self.conceptCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: indexPath.section), at: .centeredHorizontally, animated: true)
            self.conceptCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.conceptCollectionView.frame.size
        return CGSize(width: 100.0, height: size.height)
    }
    
}


//MARK: - EXTENSION FOR CONCEPT CELL -

extension OfferBannerCell{
    
    private func configureConceptCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.conceptCollectionView.dequeueReusableCell(withReuseIdentifier: .offerTabsTopCell, for: indexPath) as! OfferTabsTopCell
        
        if isLoading{
            cell.setSkeletonView()
            cell.backView.layer.borderWidth = 0
            
        }else{
            cell.hideSkeletonView()
            cell.nameLbl.isHidden = true
            cell.offerImageView.isHidden = false
            
            if let imageURL = URL(string: "\(self.mediaURL)\(self.arrayOfConcept[indexPath.row].image ?? "")"){
                cell.offerImageView.kf.indicatorType = .activity
                cell.offerImageView.kf.setImage(with: imageURL)
            }
            
            if let index = self.arrayOfConcept.firstIndex(where: {$0.id == self.selectedConceptID}){
                if index == indexPath.row{
                    cell.backView.layer.borderWidth = 1
                }else{
                    cell.backView.layer.borderWidth = 0
                }
            }else{
                cell.backView.layer.borderWidth = 0
            }
        }
        
        return cell
    }
    
}
