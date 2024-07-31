//
//  RecipesSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class RecipesSubCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!{
        didSet{
            itemImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize14
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var madeByLbl: UILabel!{
        didSet{
            madeByLbl.font = Fonts.regularFontsSize12
            madeByLbl.textColor = R.color.textGrayColor()
            madeByLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var servingLbl: UILabel!{
        didSet{
            servingLbl.font = Fonts.regularFontsSize10
            servingLbl.textColor = R.color.textGrayColor()
            servingLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var readyLbl: UILabel!{
        didSet{
            readyLbl.font = Fonts.regularFontsSize10
            readyLbl.textColor = R.color.textGrayColor()
            readyLbl.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var favoriteBtn: UIButton!{
        didSet{
            favoriteBtn.setImage(R.image.ic_recipe_unfavorite_icon(), for: .normal)
            favoriteBtn.setImage(R.image.ic_recipe_favorite_icon(), for: .selected)
            favoriteBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var userIconView: UIImageView!{
        didSet{
            userIconView.isSkeletonable = true
        }
    }
    @IBOutlet weak var readyIconView: UIImageView!{
        didSet{
            readyIconView.isSkeletonable = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showLoadingView(){
        itemImageView.showAnimatedGradientSkeleton()
        titleLbl.showAnimatedGradientSkeleton()
        madeByLbl.showAnimatedGradientSkeleton()
        servingLbl.showAnimatedGradientSkeleton()
        readyLbl.showAnimatedGradientSkeleton()
        favoriteBtn.showAnimatedGradientSkeleton()
        userIconView.showAnimatedGradientSkeleton()
        readyIconView.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView(){
        itemImageView.hideSkeleton()
        titleLbl.hideSkeleton()
        madeByLbl.hideSkeleton()
        servingLbl.hideSkeleton()
        readyLbl.hideSkeleton()
        favoriteBtn.hideSkeleton()
        userIconView.hideSkeleton()
        readyIconView.hideSkeleton()
    }

}
