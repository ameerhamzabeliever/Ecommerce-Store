//
//  PreferencesDataCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class PreferencesDataCell: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!{
        didSet{
            checkBtn.tintColor = .clear
            checkBtn.setImage(R.image.ic_preferences_uncheck_(), for: .normal)
            checkBtn.setImage(R.image.ic_preferences_check_(), for: .selected)
        }
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize12
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var verticalSeperatorView: UIView!
    @IBOutlet weak var horizontalSeperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        checkBtn.isHidden = true
        titleLbl.showAnimatedGradientSkeleton()
        dropDownImageView.isHidden = true
        verticalSeperatorView.isHidden = true
        horizontalSeperatorView.isHidden = true
    }
    
    func hideSkeletonView(){
        checkBtn.isHidden = false
        titleLbl.hideSkeleton()
        dropDownImageView.isHidden = false
        verticalSeperatorView.isHidden = false
        horizontalSeperatorView.isHidden = false
    }
    
}
