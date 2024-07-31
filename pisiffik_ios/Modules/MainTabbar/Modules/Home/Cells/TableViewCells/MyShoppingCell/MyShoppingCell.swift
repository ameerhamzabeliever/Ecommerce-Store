//
//  MyShoppingCell.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 26/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import UIKit
import GMStepper
import SkeletonView

class MyShoppingCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!{
        didSet{
            itemImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.isSkeletonable = true
            titleLbl.font = Fonts.semiBoldFontsSize14
            titleLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var quantityLbl: UILabel!{
        didSet{
            quantityLbl.isSkeletonable = true
            quantityLbl.font = Fonts.mediumFontsSize12
            quantityLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var priceLbl: UILabel!{
        didSet{
            priceLbl.isSkeletonable = true
            priceLbl.font = Fonts.mediumFontsSize15
            priceLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var rebateLbl: UILabel!{
        didSet{
            rebateLbl.isSkeletonable = true
            rebateLbl.font = Fonts.mediumFontsSize15
            rebateLbl.textColor = R.color.lightGreenColor()
        }
    }
    @IBOutlet weak var stepperView: GMStepper!{
        didSet{
            stepperView.isSkeletonable = true
            stepperView.labelFont = Fonts.semiBoldFontsSize14 ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        }
    }

    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.isSkeletonable = true
            cancelBtn.setImage(R.image.ic_cancel_icon(), for: .normal)
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
    
    func showLoaderView(){
        itemImageView.showAnimatedGradientSkeleton()
        titleLbl.showAnimatedGradientSkeleton()
        quantityLbl.showAnimatedGradientSkeleton()
        priceLbl.showAnimatedGradientSkeleton()
        rebateLbl.showAnimatedGradientSkeleton()
        stepperView.showAnimatedGradientSkeleton()
        cancelBtn.isHidden = true
    }
    
    func hideLoaderView(){
        itemImageView.hideSkeleton()
        titleLbl.hideSkeleton()
        quantityLbl.hideSkeleton()
        priceLbl.hideSkeleton()
        rebateLbl.hideSkeleton()
        stepperView.hideSkeleton()
        cancelBtn.isHidden = false
    }
    
}
