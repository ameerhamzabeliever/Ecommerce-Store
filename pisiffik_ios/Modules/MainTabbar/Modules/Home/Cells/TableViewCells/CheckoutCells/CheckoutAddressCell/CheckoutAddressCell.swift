//
//  CheckoutAddressCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CheckoutAddressCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!{
        didSet{
            addressLbl.font = Fonts.mediumFontsSize14
            addressLbl.textColor = R.color.textGrayColor()
            addressLbl.text = PisiffikStrings.deliveryAddress()
        }
    }
    @IBOutlet weak var addressBtn: UIButton!{
        didSet{
            addressBtn.semanticContentAttribute = .forceRightToLeft
            addressBtn.titleLabel?.font = Fonts.mediumFontsSize12
            addressBtn.setTitleColor(R.color.darkGrayColor(), for: .normal)
        }
    }
    
    @IBOutlet weak var paymentMethodLbl: UILabel!{
        didSet{
            paymentMethodLbl.font = Fonts.mediumFontsSize14
            paymentMethodLbl.textColor = R.color.textGrayColor()
            paymentMethodLbl.text = PisiffikStrings.paymentMethod()
        }
    }
    @IBOutlet weak var paymentMethodBtn: UIButton!{
        didSet{
            paymentMethodBtn.semanticContentAttribute = .forceRightToLeft
            paymentMethodBtn.titleLabel?.font = Fonts.mediumFontsSize12
            paymentMethodBtn.setTitleColor(R.color.darkGrayColor(), for: .normal)
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
