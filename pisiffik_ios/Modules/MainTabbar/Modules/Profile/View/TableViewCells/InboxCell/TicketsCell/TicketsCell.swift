//
//  TicketsCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SkeletonView

class TicketsCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var ticketsImage: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!{
        didSet{
            headingLbl.font = Fonts.mediumFontsSize12
            headingLbl.textColor = R.color.textLightBlackColor()
        }
    }
    @IBOutlet weak var ticketNmbLbl: UILabel!{
        didSet{
            ticketNmbLbl.font = Fonts.mediumFontsSize12
            ticketNmbLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var statusLbl: ActiveLabel!{
        didSet{
            statusLbl.font = Fonts.mediumFontsSize12
            statusLbl.textColor = R.color.textGrayColor()
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.darkGrayColor()
        }
    }
    @IBOutlet weak var notificationReadImage: UIImageView!

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
        ticketsImage.isHidden = true
        headingLbl.isHidden = true
        ticketNmbLbl.isHidden = true
        statusLbl.isHidden = true
        dateLbl.isHidden = true
        notificationReadImage.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        ticketsImage.isHidden = false
        headingLbl.isHidden = false
        ticketNmbLbl.isHidden = false
        statusLbl.isHidden = false
        dateLbl.isHidden = false
        notificationReadImage.isHidden = false
    }
    
}
