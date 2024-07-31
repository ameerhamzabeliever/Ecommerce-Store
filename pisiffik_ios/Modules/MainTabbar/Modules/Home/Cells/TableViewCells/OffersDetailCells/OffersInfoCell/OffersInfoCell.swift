//
//  OffersInfoCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class OffersInfoCell: UITableViewCell {

    @IBOutlet weak var infoLbl: UILabel!{
        didSet{
            infoLbl.font = Fonts.mediumFontsSize18
            infoLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var specificationView: UIView!{
        didSet{
            specificationView.layer.cornerRadius = 8.0
        }
    }
    @IBOutlet weak var specificationLbl: UILabel!{
        didSet{
            specificationLbl.font = Fonts.mediumFontsSize14
            specificationLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var detailView: UIView!{
        didSet{
            detailView.layer.cornerRadius = 8.0
            detailView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var detailLbl: UILabel!{
        didSet{
            detailLbl.font = Fonts.regularFontsSize12
            detailLbl.textColor = R.color.textGrayColor()
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
