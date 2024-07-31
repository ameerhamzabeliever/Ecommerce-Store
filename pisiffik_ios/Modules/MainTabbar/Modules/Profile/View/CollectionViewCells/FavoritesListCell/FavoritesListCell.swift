//
//  FavoritesListCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class FavoritesListCell: UICollectionViewCell {
    
    @IBOutlet weak var expireLbl: UILabel!{
        didSet{
            expireLbl.font = Fonts.mediumFontsSize12
            expireLbl.textColor = R.color.textRedColor()
            expireLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var discountedPriceLbl: UILabel!{
        didSet{
            discountedPriceLbl.font = Fonts.regularFontsSize12
            discountedPriceLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var currentPriceLbl: UILabel!{
        didSet{
            currentPriceLbl.font = Fonts.boldFontsSize20
            currentPriceLbl.textColor = R.color.textBlueColor()
            currentPriceLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var itemNameLbl: UILabel!{
        didSet{
            itemNameLbl.font = Fonts.mediumFontsSize14
            itemNameLbl.textColor = R.color.textBlackColor()
            itemNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.boldFontsSize12
            pointsLbl.textColor = R.color.lightGreenColor()
            pointsLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var rebateLbl: UILabel!{
        didSet{
            rebateLbl.font = Fonts.boldFontsSize12
            rebateLbl.textColor = R.color.lightGreenColor()
            rebateLbl.isSkeletonable = true
            rebateLbl.isHidden = true
        }
    }
    @IBOutlet weak var itemImageView: UIImageView!{
        didSet{
            itemImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.tintColor = .clear
            favoriteBtn.setImage(R.image.ic_unselect_favorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_select_favorite_icon(), for: .selected)
            favoriteBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var cartBtn: UIButton!{
        didSet{
            cartBtn.tintColor = .clear
            cartBtn.setImage(R.image.ic_unselect_cart_list_icon(), for: .normal)
            cartBtn.isSkeletonable = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        itemNameLbl.showAnimatedGradientSkeleton()
        currentPriceLbl.showAnimatedGradientSkeleton()
        discountedPriceLbl.isHidden = true
        pointsLbl.showAnimatedGradientSkeleton()
        itemImageView.showAnimatedGradientSkeleton()
        favoriteBtn.showAnimatedGradientSkeleton()
        cartBtn.showAnimatedGradientSkeleton()
        expireLbl.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        itemNameLbl.hideSkeleton()
        currentPriceLbl.hideSkeleton()
        discountedPriceLbl.isHidden = false
        pointsLbl.hideSkeleton()
        itemImageView.hideSkeleton()
        favoriteBtn.hideSkeleton()
        cartBtn.hideSkeleton()
        expireLbl.hideSkeleton()
    }

}
