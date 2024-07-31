//
//  MyPurchaseCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 08/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class MyPurchaseCell: UITableViewCell {

    @IBOutlet weak var statusLbl: UILabel!{
        didSet{
            statusLbl.font = Fonts.mediumFontsSize16
            statusLbl.textColor = R.color.textBlackColor()
            statusLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var checkStatusBtn: UIButton!{
        didSet{
            checkStatusBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var orderNmbLbl: UILabel!{
        didSet{
            orderNmbLbl.font = Fonts.mediumFontsSize14
            orderNmbLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize12
            dateLbl.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var orderCollectionView: UICollectionView!{
        didSet{
            orderCollectionView.delegate = self
            orderCollectionView.dataSource = self
            orderCollectionView.register(R.nib.purchaseSubCell)
        }
    }
    
    var isLoading: Bool = false{
        didSet{
            self.orderCollectionView.reloadData()
        }
    }
    var arrayOfProducts: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showSkeletonView(){
        statusLbl.showAnimatedGradientSkeleton()
        checkStatusBtn.showAnimatedGradientSkeleton()
        orderNmbLbl.showAnimatedGradientSkeleton()
        dateLbl.showAnimatedGradientSkeleton()
    }
    
    func hideSkeltonView(){
        statusLbl.hideSkeleton()
        checkStatusBtn.hideSkeleton()
        orderNmbLbl.hideSkeleton()
        dateLbl.hideSkeleton()
    }
    
}


extension MyPurchaseCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 5 : self.arrayOfProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureSubCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65.0, height: 65.0)
    }
    
}

extension MyPurchaseCell{
    
    fileprivate func configureSubCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: .purchaseSubCell, for: indexPath) as! PurchaseSubCell
        
        if isLoading{
            cell.showSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let item = self.arrayOfProducts[indexPath.row]
            if let imageURL = URL(string: item){
                cell.itemsImageView.kf.indicatorType = .activity
                cell.itemsImageView.kf.setImage(with: imageURL)
            }
        }
    
        return cell
    }
    
}
