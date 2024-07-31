//
//  MyPointsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class MyPointsCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var typeLbl: UILabel!{
        didSet{
            typeLbl.font = Fonts.mediumFontsSize12
            typeLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.mediumFontsSize12
            pointsLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var orderOnLbl: UILabel!{
        didSet{
            orderOnLbl.font = Fonts.mediumFontsSize12
            orderOnLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.textGrayColor()
        }
    }
        
    @IBOutlet weak var icLeftChevronImageView: UIImageView!{
        didSet{
            icLeftChevronImageView.tintColor = R.color.textBlackColor()
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
    
    func showSkeletonView(){
        self.backView.showAnimatedGradientSkeleton()
        self.typeLbl.isHidden = true
        self.pointsLbl.isHidden = true
        self.orderOnLbl.isHidden = true
        self.dateLbl.isHidden = true
        self.icLeftChevronImageView.isHidden = true
    }
    
    func hideSkeletonView(){
        self.backView.hideSkeleton()
        self.typeLbl.isHidden = false
        self.pointsLbl.isHidden = false
        self.orderOnLbl.isHidden = false
        self.dateLbl.isHidden = false
        self.icLeftChevronImageView.isHidden = false
    }
    
}
