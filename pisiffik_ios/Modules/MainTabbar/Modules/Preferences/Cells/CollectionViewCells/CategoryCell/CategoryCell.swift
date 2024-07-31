//
//  CategoryCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class CategoryCell: UICollectionViewCell {

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
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        itemNameLbl.showAnimatedGradientSkeleton()
        itemImageView.showAnimatedGradientSkeleton()
        selectionImageView.isHidden = true
    }
    
    func hideSkeletonView(){
        itemNameLbl.hideSkeleton()
        itemImageView.hideSkeleton()
        selectionImageView.isHidden = false
    }

}
