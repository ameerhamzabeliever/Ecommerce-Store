//
//  PurchaseSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class PurchaseSubCell: UICollectionViewCell {

    @IBOutlet weak var itemsImageView: UIImageView!{
        didSet{
            itemsImageView.isSkeletonable = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showSkeletonView(){
        itemsImageView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        itemsImageView.hideSkeleton()
    }

}
