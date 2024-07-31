//
//  PaymentCardCell.swift
//  pisiffik_ios
//
//  Created by APPLE on 6/17/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class PaymentCardCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cardNmbLbl: UILabel!{
        didSet{
            cardNmbLbl.font = Fonts.mediumFontsSize14
            cardNmbLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardTypeLbl: UILabel!{
        didSet{
            cardTypeLbl.font = Fonts.mediumFontsSize14
            cardTypeLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var expiryLbl: UILabel!{
        didSet{
            expiryLbl.font = Fonts.mediumFontsSize14
            expiryLbl.textColor = R.color.textGrayColor()
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
