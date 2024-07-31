//
//  EventDetailCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel
import SkeletonView

protocol EventDetailCellDelegates {
    func didTapOnEventCell(storeIndex: Int,dateIndex: Int,timeIndex: Int,isSelected: Bool)
}

class EventDetailCell: UITableViewCell {
    
    
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
    @IBOutlet weak var directionBtn: UIButton!{
        didSet{
            directionBtn.titleLabel?.font = Fonts.mediumFontsSize14
            directionBtn.setTitleColor(R.color.lightBlueColor(), for: .normal)
        }
    }
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var eventsTableView: ContentSizedTableView!{
        didSet{
            eventsTableView.delegate = self
            eventsTableView.dataSource = self
            eventsTableView.register(R.nib.eventDetailSubCell)
        }
    }
    
    var isLoading : Bool = false{
        didSet{
            self.eventsTableView.reloadData()
        }
    }
    var arrayOfDate : [EventDetailDate] = []{
        didSet{
            self.eventsTableView.reloadData()
        }
    }
    var storeIndex: Int = 0
    var delegate: EventDetailCellDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        storeImageView.showAnimatedGradientSkeleton()
        distanceLbl.isHidden = true
        addressLbl.showAnimatedGradientSkeleton()
        directionBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        storeImageView.hideSkeleton()
        distanceLbl.isHidden = false
        addressLbl.hideSkeleton()
        directionBtn.isHidden = false
    }
    
}


//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension EventDetailCell: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 2 : self.arrayOfDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureEventCell(at: indexPath)
    }
    
}

//MARK: - EXTENSION FOR EVENT CELL -

extension EventDetailCell{
    
    private func configureEventCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: .eventDetailSubCell, for: indexPath) as! EventDetailSubCell
        
        if isLoading {
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            cell.delegate = self
            cell.dateIndex = indexPath.row
            let arrayOfTime = self.arrayOfDate[indexPath.row].times
            if let date = self.arrayOfDate[indexPath.row].date{
                cell.dateLbl.text = date.convertToDate()
                cell.arrayOfTime = arrayOfTime
            }else{
                cell.dateLbl.text = ""
                cell.arrayOfTime = []
            }
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR EventDetailSubCellDelegates -

extension EventDetailCell: EventDetailSubCellDelegates{
    
    func didTapTEventTimeCell(dateIndex: Int, timeIndex: Int, isSelected: Bool) {
        self.delegate?.didTapOnEventCell(storeIndex: self.storeIndex, dateIndex: dateIndex, timeIndex: timeIndex, isSelected: isSelected)
    }
    
    
}
