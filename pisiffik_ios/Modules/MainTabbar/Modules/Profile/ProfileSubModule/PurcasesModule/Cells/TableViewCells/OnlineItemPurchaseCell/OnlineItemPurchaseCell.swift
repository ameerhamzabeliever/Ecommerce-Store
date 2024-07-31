//
//  OnlineItemPurchaseCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class OnlineItemPurchaseCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!{
        didSet{
            itemNameLbl.font = Fonts.mediumFontsSize14
            itemNameLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var currentPriceLbl: UILabel!{
        didSet{
            currentPriceLbl.font = Fonts.semiBoldFontsSize16
            currentPriceLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var discountedPriceLbl: UILabel!{
        didSet{
            discountedPriceLbl.font = Fonts.regularFontsSize12
            discountedPriceLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.boldFontsSize12
            pointsLbl.textColor = R.color.lightGreenColor()
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
    
    func showSkeletonView(){
        backView.showAnimatedGradientSkeleton()
        itemImageView.isHidden = true
        itemNameLbl.isHidden = true
        currentPriceLbl.isHidden = true
        discountedPriceLbl.isHidden = true
        pointsLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        itemImageView.isHidden = false
        itemNameLbl.isHidden = false
        currentPriceLbl.isHidden = false
        discountedPriceLbl.isHidden = false
        pointsLbl.isHidden = false
    }
    
}
