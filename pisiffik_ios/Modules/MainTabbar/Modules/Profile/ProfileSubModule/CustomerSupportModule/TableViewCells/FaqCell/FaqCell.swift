//
//  FaqCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class FaqCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.font = Fonts.mediumFontsSize14
            nameLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var trailingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        backView.showAnimatedGradientSkeleton()
        leadingImage.isHidden = true
        nameLbl.isHidden = true
        trailingImage.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        leadingImage.isHidden = false
        nameLbl.isHidden = false
        trailingImage.isHidden = false
    }
    
}
