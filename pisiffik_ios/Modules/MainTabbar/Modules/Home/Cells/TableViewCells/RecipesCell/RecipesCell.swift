//
//  RecipesCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 10/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

protocol RecipesCellDelagtes{
    func didTapOnRecipeCell(at indexPath: IndexPath,id: Int)
    func didTapOnRecipeFavoriteBtn(at indexPath: IndexPath,id: Int)
}

class RecipesCell: UITableViewCell {
    
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
        }
    }
    
    @IBOutlet weak var receipesCollectionView: UICollectionView!{
        didSet{
            receipesCollectionView.delegate = self
            receipesCollectionView.dataSource = self
            receipesCollectionView.register(R.nib.recipesSubCell)
        }
    }
    
    var delegate : RecipesCellDelagtes?
    
    var arrayOfRecipies : [HomeRecipiesData] = []
    
    private var isLoading: Bool = false{
        didSet{
            receipesCollectionView.reloadData()
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
        titleLbl.showAnimatedGradientSkeleton()
        seeAllBtn.isHidden = true
        isLoading = true
    }
    
    func hideLoadingView(){
        titleLbl.hideSkeleton()
        seeAllBtn.isHidden = false
        isLoading = false
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension RecipesCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 10 : self.arrayOfRecipies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureRecipesCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        if let id = self.arrayOfRecipies[indexPath.row].id{
            self.delegate?.didTapOnRecipeCell(at: indexPath, id: id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 260.0)
    }
    
}

//MARK: - EXTENSION FOR RECIPES CELL -

extension RecipesCell{
    
    fileprivate func configureRecipesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = receipesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
        if isLoading{
            cell.showLoadingView()
        }else{
            cell.hideLoadingView()
            let recipe = self.arrayOfRecipies[indexPath.row]
            cell.titleLbl.text = recipe.name ?? ""
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.chef ?? "")"
            cell.servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.servedPersons ?? 0)"
            cell.readyLbl.text = "\(PisiffikStrings.time()): \(recipe.preparationTime ?? "") \(PisiffikStrings.min())"
            
            if recipe.is_favorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                self?.delegate?.didTapOnRecipeFavoriteBtn(at: indexPath, id: 1)
                if cell.favoriteBtn.isSelected{
                    cell.favoriteBtn.isSelected = false
                }else{
                    cell.favoriteBtn.isSelected = true
                }
            }
            
        }
        
        return cell
    }
    
}


//MARK: - RECIPE CELL DELEGATE EXTENSION -

extension RecipesCellDelagtes{
    
    func didTapOnRecipeCell(at indexPath: IndexPath,id: Int) {}
    func didTapOnRecipeFavoriteBtn(at indexPath: IndexPath,id: Int) {}
    
}
