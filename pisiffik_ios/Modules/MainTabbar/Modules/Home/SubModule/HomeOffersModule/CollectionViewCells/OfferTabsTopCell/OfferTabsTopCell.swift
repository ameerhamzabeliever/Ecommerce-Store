//
//  OfferTabsTopCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 21/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class OfferTabsTopCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.font = Fonts.semiBoldFontsSize14
            nameLbl.textColor = R.color.textBlueColor()
            nameLbl.text = PisiffikStrings.allOffers()
        }
    }
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var offerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        backView.showAnimatedGradientSkeleton()
        nameLbl.isHidden = true
        offerImageView.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        nameLbl.isHidden = false
        offerImageView.isHidden = false
    }

}
