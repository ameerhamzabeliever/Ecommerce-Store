//
//  OfferSinglePurchaseCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class OfferSinglePurchaseCell: UITableViewCell {

    @IBOutlet weak var singalPurchaseImage: UIImageView!
    @IBOutlet weak var singlePurchaseLbl: UILabel!{
        didSet{
            singlePurchaseLbl.font = Fonts.mediumFontsSize14
            singlePurchaseLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var priceLbl: UILabel!{
        didSet{
            priceLbl.font = Fonts.boldFontsSize16
            priceLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var stockLbl: UILabel!{
        didSet{
            stockLbl.font = Fonts.regularFontsSize12
            stockLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var discountedPriceLbl: UILabel!{
        didSet{
            discountedPriceLbl.font = Fonts.regularFontsSize12
            discountedPriceLbl.textColor = R.color.textGrayColor()
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
