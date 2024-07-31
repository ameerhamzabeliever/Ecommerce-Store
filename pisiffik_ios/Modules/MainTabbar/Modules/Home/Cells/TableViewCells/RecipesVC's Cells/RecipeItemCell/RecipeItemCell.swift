//
//  RecipeItemCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class RecipeItemCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.isSkeletonable = true
        }
    }
    @IBOutlet weak var itemSelectionImage: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!{
        didSet{
            itemNameLbl.font = Fonts.mediumFontsSize12
            itemNameLbl.textColor = R.color.textBlackColor()
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
        bgView.showAnimatedGradientSkeleton()
        itemSelectionImage.isHidden = true
        itemNameLbl.isHidden = true
    }
    
    func hideLoadingView(){
        bgView.hideSkeleton()
        itemSelectionImage.isHidden = false
        itemNameLbl.isHidden = false
    }
    
}
