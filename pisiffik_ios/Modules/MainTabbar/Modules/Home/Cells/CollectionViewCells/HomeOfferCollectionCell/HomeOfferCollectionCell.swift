//
//  HomeOfferCollectionCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class HomeOfferCollectionCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!{
        didSet{
            itemImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.setImage(R.image.ic_unselect_favorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_select_favorite_icon(), for: .selected)
            favoriteBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var cartListBtn: UIButton!{
        didSet{
            cartListBtn.setImage(R.image.ic_unselect_cart_list_icon(), for: .normal)
            cartListBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.semiBoldFontsSize14
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var priceLbl: UILabel!{
        didSet{
            priceLbl.font = Fonts.boldFontsSize20
            priceLbl.textColor = R.color.textBlueColor()
            priceLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var expireLbl: UILabel!{
        didSet{
            expireLbl.font = Fonts.mediumFontsSize10
            expireLbl.textColor = R.color.textRedColor()
            expireLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var discountPrice: UILabel!{
        didSet{
            discountPrice.font = Fonts.mediumFontsSize10
            discountPrice.textColor = R.color.textGrayColor()
            discountPrice.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.boldFontsSize10
            pointsLbl.textColor = R.color.lightGreenColor()
            pointsLbl.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showLoadingView(){
        itemImageView.showAnimatedGradientSkeleton()
        favoriteBtn.showAnimatedGradientSkeleton()
        cartListBtn.showAnimatedGradientSkeleton()
        titleLbl.showAnimatedGradientSkeleton()
        priceLbl.showAnimatedGradientSkeleton()
        expireLbl.showAnimatedGradientSkeleton()
        discountPrice.showAnimatedGradientSkeleton()
        pointsLbl.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView(){
        itemImageView.hideSkeleton()
        favoriteBtn.hideSkeleton()
        cartListBtn.hideSkeleton()
        titleLbl.hideSkeleton()
        priceLbl.hideSkeleton()
        expireLbl.hideSkeleton()
        discountPrice.hideSkeleton()
        pointsLbl.hideSkeleton()
    }

}
