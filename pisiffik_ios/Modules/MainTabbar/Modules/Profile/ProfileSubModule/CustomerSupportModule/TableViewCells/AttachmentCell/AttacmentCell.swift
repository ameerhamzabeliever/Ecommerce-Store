//
//  AttacmentCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class AttacmentCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLbl: UILabel!{
        didSet{
            fileNameLbl.font = Fonts.mediumFontsSize14
            fileNameLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var fileSizeLbl: UILabel!{
        didSet{
            fileSizeLbl.font = Fonts.regularFontsSize12
            fileSizeLbl.textColor = R.color.textLightGrayColor()
        }
    }
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
