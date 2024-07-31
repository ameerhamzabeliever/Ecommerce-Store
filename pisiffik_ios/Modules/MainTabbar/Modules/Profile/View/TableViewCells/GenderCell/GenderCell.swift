//
//  GenderCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class GenderCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var genderLbl: UILabel!{
        didSet{
            genderLbl.textColor = R.color.textBlackColor()
            genderLbl.font = Fonts.mediumFontsSize14
            genderLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        genderImage.isHidden = true
        genderLbl.showAnimatedGradientSkeleton()
        seperator.isHidden = true
    }
    
    func hideSkeletonView(){
        genderImage.isHidden = false
        genderLbl.hideSkeleton()
        seperator.isHidden = false
    }
    
}
