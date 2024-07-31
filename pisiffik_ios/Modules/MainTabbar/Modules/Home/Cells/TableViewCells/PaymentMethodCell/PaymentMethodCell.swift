//
//  PaymentMethodCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentNameLbl: UILabel!{
        didSet{
            paymentNameLbl.font = Fonts.mediumFontsSize14
            paymentNameLbl.textColor = R.color.textBlackColor()
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
