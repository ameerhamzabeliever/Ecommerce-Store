//
//  CampaignsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class CampaignsCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var campaignImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showSkeletonView(){
        self.backView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        self.backView.hideSkeleton()
    }
    
}
