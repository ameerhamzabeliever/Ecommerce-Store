//
//  CheckoutAmountCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CheckoutAmountCell: UITableViewCell {

    @IBOutlet weak var vatLbl: UILabel!{
        didSet{
            vatLbl.font = Fonts.mediumFontsSize14
            vatLbl.textColor = R.color.textGrayColor()
            vatLbl.text = PisiffikStrings.totalVAT()
        }
    }
    @IBOutlet weak var vatPriceLbl: UILabel!{
        didSet{
            vatPriceLbl.font = Fonts.mediumFontsSize14
            vatPriceLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var deliveryLbl: UILabel!{
        didSet{
            deliveryLbl.font = Fonts.mediumFontsSize14
            deliveryLbl.textColor = R.color.textGrayColor()
            deliveryLbl.text = PisiffikStrings.deliveryFee()
        }
    }
    @IBOutlet weak var deliveryFeeBtn: UIButton!
    @IBOutlet weak var deliveryPriceLbl: UILabel!{
        didSet{
            deliveryPriceLbl.font = Fonts.mediumFontsSize14
            deliveryPriceLbl.textColor = R.color.textGrayColor()
            deliveryPriceLbl.text = PisiffikStrings.free()
        }
    }
    @IBOutlet weak var rebateLbl: UILabel!{
        didSet{
            rebateLbl.font = Fonts.mediumFontsSize14
            rebateLbl.textColor = R.color.textGrayColor()
            rebateLbl.text = PisiffikStrings.rebate()
        }
    }
    @IBOutlet weak var rebatePointsLbl: UILabel!{
        didSet{
            rebatePointsLbl.font = Fonts.mediumFontsSize14
            rebatePointsLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var totalAmountLbl: UILabel!{
        didSet{
            totalAmountLbl.font = Fonts.mediumFontsSize15
            totalAmountLbl.textColor = R.color.textBlackColor()
            totalAmountLbl.text = PisiffikStrings.totalAmountDue()
        }
    }
    @IBOutlet weak var totalPriceLbl: UILabel!{
        didSet{
            totalPriceLbl.font = Fonts.mediumFontsSize16
            totalPriceLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var toBeUsedLbl: UILabel!{
        didSet{
            toBeUsedLbl.font = Fonts.mediumFontsSize14
            toBeUsedLbl.textColor = R.color.textGrayColor()
            toBeUsedLbl.text = PisiffikStrings.pointsToBeUsed()
        }
    }
    @IBOutlet weak var toBeUsedPointsLbl: UILabel!{
        didSet{
            toBeUsedPointsLbl.font = Fonts.mediumFontsSize14
            toBeUsedPointsLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var toBeEarnedLbl: UILabel!{
        didSet{
            toBeEarnedLbl.font = Fonts.mediumFontsSize14
            toBeEarnedLbl.textColor = R.color.textGrayColor()
            toBeEarnedLbl.text = PisiffikStrings.pointsToBeEarned()
        }
    }
    @IBOutlet weak var toBeEarnedPointsLbl: UILabel!{
        didSet{
            toBeEarnedPointsLbl.font = Fonts.mediumFontsSize14
            toBeEarnedPointsLbl.textColor = R.color.lightGreenColor()
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
    
}
