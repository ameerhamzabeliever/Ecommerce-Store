//
//  OfferActivitiesCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

protocol OfferActivitiesCellDelegates{
    func didGetActivityDetail(at index: IndexPath)
}

class OfferActivitiesCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.text = PisiffikStrings.eventActivities()
            titleLbl.isSkeletonable = true
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
    @IBOutlet weak var activitiesCollectionView: UICollectionView!{
        didSet{
            activitiesCollectionView.delegate = self
            activitiesCollectionView.dataSource = self
            activitiesCollectionView.register(R.nib.offerActivitiesSubCell)
        }
    }
    
    var isLoading : Bool = false{
        didSet{
            self.activitiesCollectionView.reloadData()
        }
    }
    var arrayOfEvents : [EventsList] = []
    var delegates: OfferActivitiesCellDelegates?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        titleLbl.showAnimatedGradientSkeleton()
        seeAllBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        titleLbl.hideSkeleton()
        seeAllBtn.isHidden = false
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension OfferActivitiesCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : arrayOfEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureActivitiesCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.delegates?.didGetActivityDetail(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.activitiesCollectionView.frame.size
        if UIDevice().userInterfaceIdiom == .phone{
            return CGSize(width: (size.width * 0.75), height: size.height)
        }else{
            return CGSize(width: (size.width * 0.45), height: size.height)
        }
    }
    
}


//MARK: - EXTENSION FOR CONFIGURE CELL -

extension OfferActivitiesCell{
    
    private func configureActivitiesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: .offerActivitiesSubCell, for: indexPath) as! OfferActivitiesSubCell
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeleton()
            let event = arrayOfEvents[indexPath.row]
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(event.image ?? "")"){
                cell.eventImageView.kf.indicatorType = .activity
                cell.eventImageView.kf.setImage(with: imageURL)
            }
            cell.titleLbl.text = event.name
            cell.daysLbl.text = event.date
        }
        return cell
    }
    
}
