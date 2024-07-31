	//
//  ProfileCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.font = Fonts.mediumFontsSize14
        }
    }
    @IBOutlet weak var trailingImage: UIImageView!
    @IBOutlet weak var widthConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
