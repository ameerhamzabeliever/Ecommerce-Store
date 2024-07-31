//
//  BuyOnlineHeaderView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 15/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class BuyOnlineHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var itemsLbl: ActiveLabel!{
        didSet{
            itemsLbl.font = Fonts.mediumFontsSize14
            itemsLbl.textColor = R.color.lightBlueColor()
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
    
    func setItems(count: Int){
        let customType = ActiveType.custom(pattern: "\(PisiffikStrings.items())")
        self.itemsLbl.enabledTypes = [customType]
        self.itemsLbl.customColor[customType] = R.color.textBlackColor()
        self.itemsLbl.text = "\(PisiffikStrings.items()) (\(count))"
    }
    
}
