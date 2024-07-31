//
//  AddressCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class AddressCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    @IBOutlet weak var typeLbl: UILabel!{
        didSet{
            typeLbl.font = Fonts.mediumFontsSize14
            typeLbl.textColor = R.color.textBlackColor()
        }
    }
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!{
        didSet{
            addressLbl.font = Fonts.mediumFontsSize12
            addressLbl.textColor = R.color.textLightGrayColor()
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
        self.backView.showAnimatedGradientSkeleton()
        self.typeLbl.isHidden = true
        self.editBtn.isHidden = true
        self.deleteBtn.isHidden = true
        self.addressLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        self.backView.hideSkeleton()
        self.typeLbl.isHidden = false
        self.editBtn.isHidden = false
        self.deleteBtn.isHidden = false
        self.addressLbl.isHidden = false
    }
    
}
