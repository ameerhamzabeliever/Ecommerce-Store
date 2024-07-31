//
//  InboxReplyCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 04/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class InboxReplyCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.font = Fonts.mediumFontsSize12
            nameLbl.textColor = R.color.textLightGrayColor()
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.textColor = R.color.textLightGrayColor()
        }
    }
    @IBOutlet weak var replyBackView: UIView!{
        didSet{
            replyBackView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var replyLbl: UILabel!{
        didSet{
            replyLbl.font = Fonts.regularFontsSize12
            replyLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var attachmentBtn: UIButton!
    
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
        dateLbl.isHidden = true
        replyBackView.showAnimatedGradientSkeleton()
        replyLbl.isHidden = true
        seperatorView.isHidden = true
        attachmentBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        nameLbl.isHidden = false
        dateLbl.isHidden = false
        replyBackView.hideSkeleton()
        replyLbl.isHidden = false
        seperatorView.isHidden = false
        attachmentBtn.isHidden = false
    }
    
}
