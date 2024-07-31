//
//  CampaignSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class CampaignSubCell: UICollectionViewCell {

    @IBOutlet weak var campaingImageView: UIImageView!{
        didSet{
            campaingImageView.isSkeletonable = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showLoadingView(){
        campaingImageView.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView(){
        campaingImageView.hideSkeleton()
    }

}
