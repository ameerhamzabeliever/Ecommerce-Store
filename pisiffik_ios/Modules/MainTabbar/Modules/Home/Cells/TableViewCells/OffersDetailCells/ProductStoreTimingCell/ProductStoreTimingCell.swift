//
//  ProductStoreTimingCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/09/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class ProductStoreTimingCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var daysLbl: UILabel!{
        didSet{
            daysLbl.textColor = R.color.textGrayColor()
            daysLbl.font = Fonts.mediumFontsSize12
        }
    }
    @IBOutlet weak var timeLbl: UILabel!{
        didSet{
            timeLbl.textColor = R.color.textGrayColor()
            timeLbl.font = Fonts.mediumFontsSize12
        }
    }
    
    var isLoading : Bool = false{
        didSet{
            setupDayTimeLbl()
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
        daysLbl.isHidden = true
        timeLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        daysLbl.isHidden = false
        timeLbl.isHidden = false
    }
    
    func setupDayTimeLbl(){
        self.daysLbl.textColor = R.color.textWhiteColor()
        self.timeLbl.textColor = R.color.textWhiteColor()
        self.backView.backgroundColor = .clear
        if isLoading{
            self.timeLbl.isHidden = true
            self.daysLbl.isHidden = true
        }else{
            self.timeLbl.isHidden = false
            self.daysLbl.isHidden = false
        }
    }
    
}
