//
//  OfferItemsPagerCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import FSPagerView
import SkeletonView

class OfferItemsPagerCell: FSPagerViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        itemImageView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        itemImageView.hideSkeleton()
    }

}
