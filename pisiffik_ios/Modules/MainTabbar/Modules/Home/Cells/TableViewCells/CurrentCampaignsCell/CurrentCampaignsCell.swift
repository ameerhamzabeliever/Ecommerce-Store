//
//  CurrentCampaignsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

protocol CurrentCampaignCellDelegate{
    func didTapCampaign(at index: IndexPath)
}

class CurrentCampaignsCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = .white
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var campaignCollectionView: UICollectionView!{
        didSet{
            campaignCollectionView.delegate = self
            campaignCollectionView.dataSource = self
            campaignCollectionView.register(R.nib.campaignSubCell)
        }
    }
    @IBOutlet weak var bannerHeightConstrain: NSLayoutConstraint!{
        didSet{
            if UIDevice().userInterfaceIdiom == .pad{
                bannerHeightConstrain.constant = 210.0
            }else{
                bannerHeightConstrain.constant = 180.0
            }
        }
    }
    
    var delegate: CurrentCampaignCellDelegate?
    
    var arrayOfCampaings : [HomeCampaignData] = []
    
    private var isLoading: Bool = false{
        didSet{
            campaignCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showLoadingView(){
        titleLbl.showAnimatedGradientSkeleton()
        seeAllBtn.isHidden = true
        isLoading = true
    }
    
    func hideLoadingView(){
        titleLbl.hideSkeleton()
        seeAllBtn.isHidden = false
        isLoading = false
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METODS -

extension CurrentCampaignsCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : self.arrayOfCampaings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureSubCampaignCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.delegate?.didTapCampaign(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice().userInterfaceIdiom == .phone{
//            let width = self.campaignCollectionView.frame.size.width / 1.2
            return CGSize(width: 210.0, height: 180.0)
        }else{
//            let width = self.campaignCollectionView.frame.size.width / 2.4
            return CGSize(width: 240.0, height: 210.0)
        }
    }
    
}


//MARK: - EXTENSION FOR CAMPAIGN CELL -


extension CurrentCampaignsCell{
    
    fileprivate func configureSubCampaignCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = campaignCollectionView.dequeueReusableCell(withReuseIdentifier: .campaignSubCell, for: indexPath) as! CampaignSubCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(self.arrayOfCampaings[indexPath.row].banner ?? "")"){
                cell.campaingImageView.kf.indicatorType = .activity
                cell.campaingImageView.kf.setImage(with: url)
            }
            
        }
        
        return cell
    }
    
}
