//
//  TicketReasonCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class TicketReasonCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.textColor = R.color.textBlackColor()
            nameLbl.font = Fonts.mediumFontsSize14
            nameLbl.isSkeletonable = true
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
        nameLbl.isHidden = true
        seperator.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        nameLbl.isHidden = false
        seperator.hideSkeleton()
    }
    
}
