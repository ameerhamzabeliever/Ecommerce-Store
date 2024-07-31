//
//  MembershipOfferCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 24/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

protocol MembershipOfferCellDelegates{
    func didGetMembershipOfferProductDetail(at index: IndexPath)
    func didAddMembershipOfferToShoppingList(at index: IndexPath)
    func didTapMembershipOfferFavorite(at index: IndexPath, isFavorite: Int)
}

class MembershipOfferCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = .white
            titleLbl.text = PisiffikStrings.membershipOffers()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.tintColor = .white
            seeAllBtn.setTitleColor(.white, for: .normal)
            seeAllBtn.setTitle(PisiffikStrings.seeAll(), for: .normal)
            seeAllBtn.isSkeletonable = true
        }
    }
    @IBOutlet weak var offersCollectionView: UICollectionView!{
        didSet{
            offersCollectionView.delegate = self
            offersCollectionView.dataSource = self
            offersCollectionView.register(R.nib.favoritesGridCell)
        }
    }

    var delegate: MembershipOfferCellDelegates?
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
    
    func hideSkeltonView(){
        titleLbl.hideSkeleton()
        seeAllBtn.hideSkeleton()
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension MembershipOfferCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : self.arrayOfProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureMembershipOfferCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        self.delegate?.didGetMembershipOfferProductDetail(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.offersCollectionView.frame.width - 10)
        if UIDevice().userInterfaceIdiom == .phone{
            return CGSize(width: width / 2, height: 265.0)
        }else{
            return CGSize(width: width / 4, height: 280.0)
        }
    }
    
}


//MARK: - EXTENSION FOR CONFIGURE CELL -

extension MembershipOfferCell{
    
    private func configureMembershipOfferCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = offersCollectionView.dequeueReusableCell(withReuseIdentifier: .favoritesGridCell, for: indexPath) as! FavoritesGridCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            
            let item = self.arrayOfProducts[indexPath.row]
            
            if let images = item.images,
               let imageURL = URL(string: "\(images.first ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
            }
            
            cell.titleLbl.text = item.name
            
            if let isMember = item.isMember,
               isMember == 1{
                cell.priceLbl.text = "\(item.salePrice ?? 0.0) \(item.currency ?? "")"
                cell.discountPrice.text = ""
            }else{
                if let isDiscounted = item.isDiscountEnabled,
                   let salePrice = item.salePrice,
                   let currency = item.currency{
                    if isDiscounted{
                        cell.discountPrice.isHidden = false
                        cell.discountPrice.attributedText = "\(salePrice) \(currency)".strikeThrough()
                        cell.priceLbl.text = "\(item.afterDiscountPrice ?? 0) \(currency)"
                    }else{
                        cell.discountPrice.isHidden = true
                        cell.priceLbl.text = "\(salePrice) \(currency)"
                    }
                }else{
                    cell.discountPrice.isHidden = true
                    cell.priceLbl.text = "\(item.salePrice ?? 0) \(item.currency ?? "")"
                }
            }
            
            if let points = item.points{
                if points > 0 {
                    cell.pointsLbl.isHidden = false
                    cell.pointsLbl.text = "\(PisiffikStrings.points()): \(points)"
                }else{
                    cell.pointsLbl.isHidden = true
                }
            }else{
                cell.pointsLbl.isHidden = true
            }
            
            cell.rebateLbl.isHidden  = false
            cell.rebateLbl.text = "\(PisiffikStrings.rebate()): \(item.afterDiscountPrice ?? 0.0) kr"
            cell.pointsLbl.textColor = R.color.darkGrayColor()
            
            if let expireIn = item.expiresIn{
                if expireIn > 0{
                    cell.expireLbl.isHidden = false
                    cell.expireLbl.text = "\(PisiffikStrings.expireIn()) \(expireIn) \(PisiffikStrings.days())"
                }else{
                    cell.expireLbl.isHidden = true
                }
            }else{
                cell.expireLbl.isHidden = true
            }
            
            if let isFavorite = item.isFavorite{
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
                    if let isFavorite = item.isFavorite{
                        if isFavorite == 1{
                            cell.favoriteBtn.isSelected = false
                            self?.delegate?.didTapMembershipOfferFavorite(at: indexPath, isFavorite: isFavorite)
                        }else{
                            cell.favoriteBtn.isSelected = true
                            self?.delegate?.didTapMembershipOfferFavorite(at: indexPath, isFavorite: isFavorite)
                        }
                    }
                }
            }
            
            cell.cartListBtn.addTapGestureRecognizer { [weak self] in
                if self?.isLoading == false{
                    self?.delegate?.didAddMembershipOfferToShoppingList(at: indexPath)
                }
            }
            
            if UIDevice().userInterfaceIdiom == .phone{
                cell.imageHeightConstrain.constant = 69.5
                cell.itemImageView.contentMode = .scaleAspectFill
            }else{
                cell.imageHeightConstrain.constant = 94.5
                cell.itemImageView.contentMode = .scaleAspectFill
            }
            
        }
        
        return cell
    }
    
}
