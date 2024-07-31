//
//  CurrentOfferCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

protocol CurrentOfferDelegates{
    func didTapCurrentOffersCell(at indexPath: IndexPath)
    func didTapCurrentOfferFavoriteBtn(at indexPath: IndexPath)
    func didTapCurrentOfferCartListBtn(at indexPath: IndexPath)
}

class CurrentOfferCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = .white
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(.white, for: .normal)
            seeAllBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var sectionStackView: UIStackView!{
        didSet{
            sectionStackView.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var offersCollectionView: UICollectionView!{
        didSet{
            offersCollectionView.delegate = self
            offersCollectionView.dataSource = self
            offersCollectionView.register(R.nib.homeOfferCollectionCell)
        }
    }
    
    var delegate: CurrentOfferDelegates?
    var offerList : [OfferList] = []
    private var isLoading: Bool = false{
        didSet{
            offersCollectionView.reloadData()
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
    
    func showLoadingView(){
        sectionStackView.showAnimatedGradientSkeleton()
        titleLbl.showAnimatedGradientSkeleton()
        seeAllBtn.isHidden = true
        self.isLoading = true
    }
    
    func hideLoadingView(){
        sectionStackView.hideSkeleton()
        titleLbl.hideSkeleton()
        seeAllBtn.isHidden = false
        self.isLoading = false
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension CurrentOfferCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isLoading ? 10 : self.offerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureOfferCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isLoading { return }
        delegate?.didTapCurrentOffersCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 260.0)
    }
    
}

//MARK: - EXTENSION FOR OFFER CELL -

extension CurrentOfferCell{
    
    fileprivate func configureOfferCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = offersCollectionView.dequeueReusableCell(withReuseIdentifier: .homeOfferCollectionCell, for: indexPath) as! HomeOfferCollectionCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let offer = self.offerList[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.titleLbl.text = offer.name
            
            if let isDiscounted = offer.isDiscountEnabled,
               let salePrice = offer.salePrice,
               let currency = offer.currency{
                if isDiscounted{
                    cell.discountPrice.attributedText = "\(salePrice) \(currency)".strikeThrough()
                    cell.priceLbl.text = "\(offer.afterDiscountPrice ?? 0) \(currency)"
                }else{
                    cell.discountPrice.text = " "
                    cell.priceLbl.text = "\(salePrice) \(currency)"
                }
            }else{
                cell.discountPrice.text = " "
                cell.priceLbl.text = "\(offer.salePrice ?? 0) \(offer.currency ?? "")"
            }
            
            if let points = offer.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = true
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            if let expireIn = offer.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = true
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = offer.isFavorite{
                if isFavorite > 0{
                    cell.favoriteBtn.isSelected = true
                }else{
                    cell.favoriteBtn.isSelected = false
                }
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if cell.favoriteBtn.isSelected{
                        cell.favoriteBtn.isSelected = false
                    }else{
                        cell.favoriteBtn.isSelected = true
                    }
                    self?.delegate?.didTapCurrentOfferFavoriteBtn(at: indexPath)
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    self?.delegate?.didTapCurrentOfferCartListBtn(at: indexPath)
                }
            }
            
        }
        
        return cell
    }
    
}


//MARK: - EXTENSION FOR CurrentOfferDelegates

extension CurrentOfferDelegates{
    func didTapCurrentOffersCell(at indexPath: IndexPath) {}
    func didTapCurrentOfferFavoriteBtn(at indexPath: IndexPath) {}
    func didTapCurrentOfferCartListBtn(at indexPath: IndexPath) {}
}
