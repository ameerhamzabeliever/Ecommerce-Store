//
//  OffersEarnPointsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SkeletonView

class OffersEarnPointsCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var pointsLbl: ActiveLabel!{
        didSet{
            pointsLbl.font = Fonts.mediumFontsSize16
            pointsLbl.textColor = R.color.darkGrayColor()
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
    
    func setSkeletonView(){
        backView.showAnimatedGradientSkeleton()
        pointsLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        pointsLbl.isHidden = false
    }
    
    
}
