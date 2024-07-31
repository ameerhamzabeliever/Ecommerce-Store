//
//  OfferActivitiesSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class OfferActivitiesSubCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.semiBoldFontsSize12
            titleLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var calenderImageView: UIImageView!
    @IBOutlet weak var daysLbl: UILabel!{
        didSet{
            daysLbl.font = Fonts.mediumFontsSize12
            daysLbl.textColor = R.color.textGrayColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        eventImageView.isHidden = true
        titleLbl.isHidden = true
        daysLbl.isHidden = true
        calenderImageView.isHidden = true
    }
    
    func hideSkeletonView(){
        eventImageView.isHidden = false
        titleLbl.isHidden = false
        daysLbl.isHidden = false
        calenderImageView.isHidden = false
    }

}
