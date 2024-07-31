//
//  MyPointsHeaderView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 05/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class MyPointsHeaderView: UIView {

    @IBOutlet weak var typeLbl: UILabel!{
        didSet{
            typeLbl.font = Fonts.mediumFontsSize12
            typeLbl.textColor = R.color.textBlackColor()
            typeLbl.text = PisiffikStrings.type()
        }
    }
    @IBOutlet weak var pointsLbl: UILabel!{
        didSet{
            pointsLbl.font = Fonts.mediumFontsSize12
            pointsLbl.textColor = R.color.textBlackColor()
            pointsLbl.text = PisiffikStrings.points()
        }
    }
    @IBOutlet weak var orderNoLbl: UILabel!{
        didSet{
            orderNoLbl.font = Fonts.mediumFontsSize12
            orderNoLbl.textColor = R.color.textBlackColor()
            orderNoLbl.text = PisiffikStrings.orderNo()
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.textBlackColor()
            dateLbl.text = PisiffikStrings.date()
        }
    }
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
