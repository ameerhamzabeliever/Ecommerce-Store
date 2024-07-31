//
//  FaqDetailCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class FaqDetailCell: UITableViewCell {

    @IBOutlet weak var faqTxtLbl: UILabel!{
        didSet{
            faqTxtLbl.font = Fonts.mediumFontsSize14
            faqTxtLbl.textColor = R.color.textBlackColor()
            faqTxtLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        faqTxtLbl.showAnimatedGradientSkeleton()
        checkImage.isHidden = true
    }
    
    func hideSkeletonView(){
        faqTxtLbl.hideSkeleton()
        checkImage.isHidden = false
    }
    
}
