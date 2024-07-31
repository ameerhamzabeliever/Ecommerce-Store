//
//  EventDetailHeaderCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class EventDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!{
        didSet{
            descriptionLbl.font = Fonts.mediumFontsSize14
            descriptionLbl.textColor = R.color.textLightBlackColor()
        }
    }
    @IBOutlet weak var dateLbl: PaddingLabel!{
        didSet{
            dateLbl.font = Fonts.semiBoldFontsSize14
            dateLbl.textColor = .white
        }
    }
    @IBOutlet weak var eventImageViewConstrain: NSLayoutConstraint!{
        didSet{
            if UIDevice().userInterfaceIdiom == .pad{
                eventImageViewConstrain.constant = 280
            }else{
                eventImageViewConstrain.constant = 140
            }
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
        backView.showAnimatedGradientSkeleton()
        eventImageView.isHidden = true
        descriptionLbl.isHidden = true
        dateLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        eventImageView.isHidden = false
        descriptionLbl.isHidden = false
        dateLbl.isHidden = false
    }
    
}
