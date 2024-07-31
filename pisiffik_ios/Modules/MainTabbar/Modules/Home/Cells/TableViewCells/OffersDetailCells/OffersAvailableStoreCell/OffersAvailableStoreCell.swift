//
//  OffersAvailableStoreCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 14/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView
import ActiveLabel

class OffersAvailableStoreCell: UITableViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!{
        didSet{
            storeImageView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var distanceLbl: UILabel!{
        didSet{
            distanceLbl.font = Fonts.mediumFontsSize10
            distanceLbl.textColor = R.color.orangeColor()
        }
    }
    @IBOutlet weak var addressLbl: ActiveLabel!{
        didSet{
            addressLbl.font = Fonts.mediumFontsSize12
            addressLbl.textColor = R.color.textGrayColor()
            addressLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var openingHoursLbl: UILabel!{
        didSet{
            openingHoursLbl.font = Fonts.mediumFontsSize12
            openingHoursLbl.textColor = R.color.textBlackColor()
            openingHoursLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var directionBtn: UIButton!{
        didSet{
            directionBtn.titleLabel?.font = Fonts.mediumFontsSize14
            directionBtn.setTitleColor(R.color.lightBlueColor(), for: .normal)
            directionBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hoursTableView: ContentSizedTableView!{
        didSet{
            hoursTableView.delegate = self
            hoursTableView.dataSource = self
            hoursTableView.register(R.nib.productStoreTimingCell)
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
    
    var isLoading : Bool = false{
        didSet{
            self.hoursTableView.reloadData()
        }
    }
    var arrayOfTimings : [PisiffikItemDetailStoresTimings] = []{
        didSet{
            self.hoursTableView.reloadData()
        }
    }
    
    func setSkeletonView(){
        storeImageView.showAnimatedGradientSkeleton()
        distanceLbl.isHidden = true
        addressLbl.showAnimatedGradientSkeleton()
        openingHoursLbl.showAnimatedGradientSkeleton()
        directionBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        storeImageView.hideSkeleton()
        distanceLbl.isHidden = false
        addressLbl.hideSkeleton()
        openingHoursLbl.hideSkeleton()
        directionBtn.isHidden = false
    }
    
}


//MARK: - EXTENSION FOR TABLE VIEW CELL DELEGATES -

extension OffersAvailableStoreCell: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 15 : self.arrayOfTimings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureStoreTimingCell(at: indexPath)
    }
    
}

//MARK: - EXTENSION FOR STORE TIMING CELL -

extension OffersAvailableStoreCell{
    
    private func configureStoreTimingCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = hoursTableView.dequeueReusableCell(withIdentifier: .productStoreTimingCell, for: indexPath) as! ProductStoreTimingCell
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            cell.daysLbl.text = self.arrayOfTimings[indexPath.row].day
            cell.timeLbl.text = "\(self.arrayOfTimings[indexPath.row].from ?? "") - \(self.arrayOfTimings[indexPath.row].to ?? "")"
        }
        return cell
    }
    
}
