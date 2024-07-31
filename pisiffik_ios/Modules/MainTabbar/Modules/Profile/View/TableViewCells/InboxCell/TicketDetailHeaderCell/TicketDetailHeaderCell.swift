//
//  TicketDetailHeaderCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 18/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class TicketDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var ticketNmbLbl: UILabel!{
        didSet{
            ticketNmbLbl.font = Fonts.mediumFontsSize14
            ticketNmbLbl.textColor = R.color.textBlackColor()
            ticketNmbLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.textLightGrayColor()
        }
    }
    @IBOutlet weak var statusLbl: UILabel!{
        didSet{
            statusLbl.font = Fonts.mediumFontsSize14
            statusLbl.textColor = R.color.textBlackColor()
            statusLbl.text = "\(PisiffikStrings.status()):"
            statusLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var openLbl: UILabel!{
        didSet{
            openLbl.font = Fonts.mediumFontsSize14
            openLbl.textColor = R.color.lightGreenColor()
        }
    }
    @IBOutlet weak var subjectLbl: UILabel!{
        didSet{
            subjectLbl.font = Fonts.mediumFontsSize14
            subjectLbl.textColor = R.color.textBlackColor()
            subjectLbl.text = "\(PisiffikStrings.subject()):"
        }
    }
    @IBOutlet weak var subjectNameLbl: UILabel!{
        didSet{
            subjectNameLbl.font = Fonts.mediumFontsSize12
            subjectNameLbl.textColor = R.color.textLightGrayColor()
            subjectNameLbl.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var reasonLbl: UILabel!{
        didSet{
            reasonLbl.font = Fonts.mediumFontsSize14
            reasonLbl.textColor = R.color.textBlackColor()
            reasonLbl.text = "\(PisiffikStrings.reason()):"
        }
    }
    @IBOutlet weak var reasonNameLbl: UILabel!{
        didSet{
            reasonNameLbl.font = Fonts.mediumFontsSize12
            reasonNameLbl.textColor = R.color.textLightGrayColor()
            reasonNameLbl.isSkeletonable = true
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
    
    func setSkeletonView(){
        ticketNmbLbl.showAnimatedGradientSkeleton()
        dateLbl.isHidden = true
        statusLbl.showAnimatedGradientSkeleton()
        openLbl.isHidden = true
        subjectLbl.isHidden = true
        subjectNameLbl.showAnimatedGradientSkeleton()
        reasonLbl.isHidden = true
        reasonNameLbl.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        ticketNmbLbl.hideSkeleton()
        dateLbl.isHidden = false
        statusLbl.hideSkeleton()
        openLbl.isHidden = false
        subjectLbl.isHidden = false
        subjectNameLbl.hideSkeleton()
        reasonLbl.isHidden = false
        reasonNameLbl.hideSkeleton()
    }
    
    
}
