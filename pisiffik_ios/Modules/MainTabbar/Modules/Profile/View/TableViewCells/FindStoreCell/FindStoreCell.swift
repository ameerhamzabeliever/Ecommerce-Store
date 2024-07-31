//
//  FindStoreCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class FindStoreCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.semiBoldFontsSize14
            titleLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var distanceLbl: UILabel!{
        didSet{
            distanceLbl.font = Fonts.mediumFontsSize10
            distanceLbl.textColor = R.color.orangeColor()
        }
    }
    @IBOutlet weak var descriptionLbl: UILabel!{
        didSet{
            descriptionLbl.font = Fonts.regularFontsSize12
            descriptionLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var daysLbl: UILabel!{
        didSet{
            daysLbl.font = Fonts.mediumFontsSize12
            daysLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var openingLbl: UILabel!{
        didSet{
            openingLbl.font = Fonts.mediumFontsSize12
            openingLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var directionBtn: UIButton!{
        didSet{
            directionBtn.titleLabel?.font = Fonts.mediumFontsSize14
            directionBtn.setTitleColor(R.color.lightBlueColor(), for: .normal)
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
