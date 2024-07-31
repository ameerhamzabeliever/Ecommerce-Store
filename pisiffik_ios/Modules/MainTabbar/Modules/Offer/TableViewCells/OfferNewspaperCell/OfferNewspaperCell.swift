//
//  OfferNewspaperCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

protocol OfferNewspaperCellDelegates{
    func didTapNewsPaper(at index: IndexPath)
}

class OfferNewspaperCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.text = PisiffikStrings.offerNewspapers()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
            seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
        }
    }
    @IBOutlet weak var newspaperCollectionView: UICollectionView!{
        didSet{
            newspaperCollectionView.delegate = self
            newspaperCollectionView.dataSource = self
            newspaperCollectionView.register(R.nib.offerNewspaperSubCell)
        }
    }
    
    var delegate: OfferNewspaperCellDelegates?
    
    var isLoading: Bool = false{
        didSet{
            self.newspaperCollectionView.reloadData()
        }
    }
    var newspapers : [DigitalNewspaper] = []
    
    func setSkeletonView(){
        self.titleLbl.showAnimatedGradientSkeleton()
        self.seeAllBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        self.titleLbl.hideSkeleton()
        self.seeAllBtn.isHidden = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension OfferNewspaperCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading{
            return 3
        }else{
            return self.newspapers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureNewsPaperCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.delegate?.didTapNewsPaper(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.newspaperCollectionView.frame.size
        return CGSize(width: 140.0, height: size.height)
    }
    
}


//MARK: - EXTENSION FOR CONFIGURE CELL -

extension OfferNewspaperCell{
    
    private func configureNewsPaperCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = newspaperCollectionView.dequeueReusableCell(withReuseIdentifier: .offerNewspaperSubCell, for: indexPath) as! OfferNewspaperSubCell
        if isLoading{
            cell.setSkeletonView()
        }else{
            cell.hideSkeletonView()
            if let coverImage = URL(string: self.newspapers[indexPath.row].coverImage ?? ""){
                cell.newsPaperImage.kf.indicatorType = .activity
                cell.newsPaperImage.kf.setImage(with: coverImage)
            }
            cell.dateLbl.text = "\(self.newspapers[indexPath.row].startDate ?? "") - \(self.newspapers[indexPath.row].endDate ?? "")"
        }
        return cell
    }
    
}
