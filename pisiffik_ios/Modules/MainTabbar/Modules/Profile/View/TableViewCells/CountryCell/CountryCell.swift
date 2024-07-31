//
//  CountryCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 26/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class CountryCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.textColor = R.color.textBlackColor()
            nameLbl.font = Fonts.mediumFontsSize14
            nameLbl.isSkeletonable = true
            nameLbl.skeletonCornerRadius = 8
            nameLbl.skeletonTextLineHeight = .relativeToFont
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
    
    func showLoadingView(){
        self.nameLbl.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView(){
        self.nameLbl.hideSkeleton()
    }
    
}
