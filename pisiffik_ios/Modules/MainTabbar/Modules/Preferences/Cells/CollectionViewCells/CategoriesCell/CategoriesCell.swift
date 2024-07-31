//
//  CategoriesCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLbl: UILabel!{
        didSet{
            itemNameLbl.font = Fonts.mediumFontsSize12
            itemNameLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var itemImageView: UIImageView!{
        didSet{
            itemImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        itemNameLbl.showAnimatedGradientSkeleton()
        itemImageView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        itemNameLbl.hideSkeleton()
        itemImageView.hideSkeleton()
    }

}
