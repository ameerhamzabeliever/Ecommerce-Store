//
//  FavoritesHeaderView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SkeletonView

class FavoritesHeaderView: UICollectionReusableView {

    @IBOutlet weak var myFavoritesLbl: ActiveLabel!{
        didSet{
            myFavoritesLbl.font = Fonts.mediumFontsSize14
            myFavoritesLbl.textColor = R.color.lightBlueColor()
            myFavoritesLbl.isSkeletonable = true
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
    
    func setSkeletonView(){
        myFavoritesLbl.showAnimatedGradientSkeleton()
        gridBtn.isHidden = true
        listBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        myFavoritesLbl.hideSkeleton()
        gridBtn.isHidden = false
        listBtn.isHidden = false
    }
    
}
