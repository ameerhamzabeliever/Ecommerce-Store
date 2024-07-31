//
//  CheckoutPointsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CheckoutPointsCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize14
            titleLbl.textColor = R.color.textBlackColor()
        }
    }
    
    @IBOutlet weak var availablePointsLbl: UILabel!{
        didSet{
            availablePointsLbl.font = Fonts.mediumFontsSize14
            availablePointsLbl.textColor = R.color.textBlackColor()
        }
    }
    
    @IBOutlet weak var pointsSwitch: UISwitch!
    
    @IBOutlet weak var reedemAllLbl: UILabel!{
        didSet{
            reedemAllLbl.font = Fonts.mediumFontsSize14
            reedemAllLbl.textColor = R.color.textBlackColor()
        }
    }
    
    @IBOutlet weak var currentPointsLbl: UILabel!{
        didSet{
            currentPointsLbl.font = Fonts.semiBoldFontsSize16
            currentPointsLbl.textColor = R.color.textWhiteColor()
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.mediumFontsSize10
            pointsLbl.textColor = .white
        }
    }
    @IBOutlet weak var currentPriceLbl: UILabel!{
        didSet{
            currentPriceLbl.font = Fonts.mediumFontsSize12
            currentPriceLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var currencyLbl: UILabel!{
        didSet{
            currencyLbl.font = Fonts.regularFontsSize10
            currencyLbl.textColor = R.color.textBlackColor()
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
