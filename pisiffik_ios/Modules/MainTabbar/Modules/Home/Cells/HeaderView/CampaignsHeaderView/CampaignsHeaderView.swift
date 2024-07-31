//
//  CampaignsHeaderView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class CampaignsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var campaignImageView: UIImageView!
    @IBOutlet weak var campaignImageConstrain: NSLayoutConstraint!{
        didSet{
            if UIDevice().userInterfaceIdiom == .pad{
                campaignImageConstrain.constant = 850.0
            }else{
                campaignImageConstrain.constant = 320.0
            }
        }
    }
    @IBOutlet weak var itemsLbl: ActiveLabel!{
        didSet{
            itemsLbl.font = Fonts.mediumFontsSize14
            itemsLbl.textColor = R.color.textBlueColor()
        }
    }
    @IBOutlet weak var gridBtn: UIButton!{
        didSet{
            gridBtn.tintColor = .clear
            gridBtn.setImage(R.image.ic_unselect_grid_icon(), for: .normal)
            gridBtn.setImage(R.image.ic_select_grid_icon(), for: .selected)
            gridBtn.isSelected = true
        }
    }
    @IBOutlet weak var listBtn: UIButton!{
        didSet{
            listBtn.tintColor = .clear
            listBtn.setImage(R.image.ic_unselect_list_icon(), for: .normal)
            listBtn.setImage(R.image.ic_select_list_icon(), for: .selected)
            listBtn.isSelected = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
