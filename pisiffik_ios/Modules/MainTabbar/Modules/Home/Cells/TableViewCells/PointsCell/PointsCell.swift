//
//  PointsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class PointsCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var pointOverviewLbl: UILabel!{
        didSet{
            pointOverviewLbl.font = Fonts.mediumFontsSize14
            pointOverviewLbl.textColor = R.color.textBlackColor()
            pointOverviewLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var viewDetailBtn: UIButton!{
        didSet{
            viewDetailBtn.titleLabel?.font = Fonts.mediumFontsSize14
            viewDetailBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.boldFontsSize27
            pointsLbl.textColor = R.color.lightGreenColor()
            pointsLbl.isSkeletonable = true
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
        backView.showAnimatedGradientSkeleton()
        pointOverviewLbl.showAnimatedGradientSkeleton()
        viewDetailBtn.showAnimatedGradientSkeleton()
        pointsLbl.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView(){
        backView.hideSkeleton()
        pointOverviewLbl.hideSkeleton()
        viewDetailBtn.hideSkeleton()
        pointsLbl.hideSkeleton()
    }
    
}
