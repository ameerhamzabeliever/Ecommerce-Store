//
//  EventDetailSubCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

protocol EventDetailSubCellDelegates{
    func didTapTEventTimeCell(dateIndex: Int,timeIndex: Int,isSelected: Bool)
}

class EventDetailSubCell: UITableViewCell {

    
    @IBOutlet weak var dateLbl: UILabel!{
        didSet{
            dateLbl.font = Fonts.mediumFontsSize14
            dateLbl.textColor = R.color.lightBlueColor()
        }
    }
    @IBOutlet weak var timeTableView: ContentSizedTableView!{
        didSet{
            timeTableView.delegate = self
            timeTableView.dataSource = self
            timeTableView.register(R.nib.eventDetailTimeCell)
        }
    }
    
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.isSkeletonable = true
        }
    }
    
    var dateIndex : Int = 0
    var delegate : EventDetailSubCellDelegates?
    
    var arrayOfTime : [EventDetailTime] = []{
        didSet{
            self.timeTableView.reloadData()
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
        backView.showAnimatedGradientSkeleton()
        dateLbl.isHidden = true
    }
    
    func hideSkeletonView(){
        backView.hideSkeleton()
        dateLbl.isHidden = false
    }
    
}

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension EventDetailSubCell: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(at: indexPath)
    }
    
}

//MARK: - EXTENSION FOR CELL -

extension EventDetailSubCell{
    
    private func configureCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = timeTableView.dequeueReusableCell(withIdentifier: .eventDetailTimeCell, for: indexPath) as! EventDetailTimeCell
        
        if let startTime = arrayOfTime[indexPath.row].startTime, let endTime = arrayOfTime[indexPath.row].endTime{
            cell.timeLbl.text = "\(startTime) - \(endTime)"
            if let isSelected = arrayOfTime[indexPath.row].isSelected{
                if isSelected{
                    cell.checkBoxImageView.image = R.image.ic_add_event()
                }else{
                    cell.checkBoxImageView.image = R.image.ic_remove_event()
                }
            }else{
                cell.checkBoxImageView.image = R.image.ic_remove_event()
            }
            
            cell.checkBoxImageView.addTapGestureRecognizer { [weak self] in
                guard let self = self else {return}
                if let isSelected = self.arrayOfTime[indexPath.row].isSelected{
                    if isSelected{
                        self.arrayOfTime[indexPath.row].isSelected = false
                    }else{
                        self.arrayOfTime[indexPath.row].isSelected = true
                    }
                }else{
                    self.arrayOfTime[indexPath.row].isSelected = true
                }
                self.delegate?.didTapTEventTimeCell(dateIndex: self.dateIndex, timeIndex: indexPath.row, isSelected: self.arrayOfTime[indexPath.row].isSelected ?? false)
                self.timeTableView.reloadData()
            }
            
        }else{
            cell.timeLbl.text = ""
        }
        return cell
    }
    
}
