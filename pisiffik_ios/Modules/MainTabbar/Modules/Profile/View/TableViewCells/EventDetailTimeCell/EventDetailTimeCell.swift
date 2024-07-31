//
//  EventDetailTimeCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 25/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class EventDetailTimeCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!{
        didSet{
            timeLbl.font = Fonts.mediumFontsSize12
            timeLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
