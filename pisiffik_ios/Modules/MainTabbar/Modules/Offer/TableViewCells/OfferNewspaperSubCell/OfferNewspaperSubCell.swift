//
//  OfferNewspaperSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class OfferNewspaperSubCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var newsPaperImage: UIImageView!
    @IBOutlet weak var validFromLbl: UILabel!{
        didSet{
            validFromLbl.font = Fonts.mediumFontsSize12
            validFromLbl.textColor = R.color.textBlackColor()
            validFromLbl.text = PisiffikStrings.validFrom()
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.textGrayColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSkeletonView(){
        self.backView.showAnimatedGradientSkeleton()
        self.newsPaperImage.isHidden = true
        self.validFromLbl.isHidden = true
        self.dateLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        self.backView.hideSkeleton()
        self.newsPaperImage.isHidden = false
        self.validFromLbl.isHidden = false
        self.dateLbl.isHidden = false
    }

}
