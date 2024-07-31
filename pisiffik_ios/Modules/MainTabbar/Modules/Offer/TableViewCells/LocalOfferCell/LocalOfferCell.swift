//
//  LocalOfferCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

protocol LocalOfferCellDelegates{
    func didGetLocalOfferProductDetail(at index: IndexPath)
    func didAddLocalOfferToShoppingList(at index: IndexPath)
    func didTapLocalOfferFavorite(at index: IndexPath,isFavorite: Int)
}

class LocalOfferCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.text = PisiffikStrings.localOffers()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
            seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            seeAllBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var offersCollectionView: UICollectionView!{
        didSet{
            offersCollectionView.delegate = self
            offersCollectionView.dataSource = self
            offersCollectionView.register(R.nib.personalOfferListCell)
        }
    }
    
    var delegate: LocalOfferCellDelegates?
    var isLoading: Bool = false{
        didSet{
            self.offersCollectionView.reloadData()
        }
    }
    var arrayOfProducts: [OfferList] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSkeletonView(){
        titleLbl.showAnimatedGradientSkeleton()
        seeAllBtn.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView(){
        titleLbl.hideSkeleton()
        seeAllBtn.hideSkeleton()
    }
    
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension LocalOfferCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : self.arrayOfProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configurePersonalOfferCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.delegate?.didGetLocalOfferProductDetail(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.offersCollectionView.frame.size
        if UIDevice().userInterfaceIdiom == .phone{
            return CGSize(width: (size.width * 0.90), height: size.height)
        }else{
            return CGSize(width: (size.width * 0.60), height: size.height)
        }
    }
    
}


//MARK: - EXTENSION FOR CONFIGURE CELL -

extension LocalOfferCell{
    
    private func configurePersonalOfferCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = offersCollectionView.dequeueReusableCell(withReuseIdentifier: .personalOfferListCell, for: indexPath) as! PersonalOfferListCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            let offer = self.arrayOfProducts[indexPath.row]
            
            if let images = offer.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.itemNameLbl.text = offer.name
            
            if let isDiscounted = offer.isDiscountEnabled,
               let salePrice = offer.salePrice,
               let currency = offer.currency{
                if isDiscounted{
                    cell.discountedPriceLbl.isHidden = false
                    cell.discountedPriceLbl.attributedText = "\(salePrice) \(currency)".strikeThrough()
                    cell.currentPriceLbl.text = "\(offer.afterDiscountPrice ?? 0) \(currency)"
                }else{
                    cell.discountedPriceLbl.isHidden = true
                    cell.currentPriceLbl.text = "\(salePrice) \(currency)"
                }
            }else{
                cell.discountedPriceLbl.isHidden = true
                cell.currentPriceLbl.text = "\(offer.salePrice ?? 0) \(offer.currency ?? "")"
            }
            
            if let points = offer.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = ""
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            if let expireIn = offer.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = ""
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = offer.isFavorite,
               isFavorite > 0{
                cell.favoriteBtn.isSelected = true
            }else{
                cell.favoriteBtn.isSelected = false
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    if let isFavorite = offer.isFavorite{
                        if isFavorite == 1{
                            cell.favoriteBtn.isSelected = false
                            self?.delegate?.didTapLocalOfferFavorite(at: indexPath, isFavorite: isFavorite)
                        }else{
                            cell.favoriteBtn.isSelected = true
                            self?.delegate?.didTapLocalOfferFavorite(at: indexPath, isFavorite: isFavorite)
                        }
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    self?.delegate?.didAddLocalOfferToShoppingList(at: indexPath)
                }
            }
            
        }
            
        return cell
    }
    
}
