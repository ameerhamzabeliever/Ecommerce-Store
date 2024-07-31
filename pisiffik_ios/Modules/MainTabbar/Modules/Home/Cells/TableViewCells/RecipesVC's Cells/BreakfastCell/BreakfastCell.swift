//
//  BreakfastCell.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 13/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SkeletonView

class BreakfastCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            titleLbl.font = Fonts.mediumFontsSize18
            titleLbl.textColor = R.color.textBlackColor()
            titleLbl.isSkeletonable = true
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton!{
        didSet{
            seeAllBtn.semanticContentAttribute = .forceRightToLeft
            seeAllBtn.titleLabel?.font = Fonts.mediumFontsSize12
            seeAllBtn.setTitleColor(R.color.textGrayColor(), for: .normal)
        }
    }
    
    @IBOutlet weak var receipesCollectionView: UICollectionView!{
        didSet{
            receipesCollectionView.delegate = self
            receipesCollectionView.dataSource = self
            receipesCollectionView.register(R.nib.recipesSubCell)
        }
    }
    
    var isLoading : Bool = false{
        didSet{
            self.receipesCollectionView.reloadData()
        }
    }
    var indexPath : IndexPath = IndexPath()
    var arrayOfRecipes : [RecipeDetailAboutData] = []
    var delegate : RecipesCellDelagtes?
    
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
        seeAllBtn.isHidden = true
    }
    
    func hideSkeletonView(){
        titleLbl.hideSkeleton()
        seeAllBtn.isHidden = false
    }
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension BreakfastCell: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading ? 15 : self.arrayOfRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureRecipesCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {return}
        guard let recipeID = self.arrayOfRecipes[indexPath.row].id else {return}
        self.delegate?.didTapOnRecipeCell(at: self.indexPath, id: recipeID)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 260.0)
    }
    
}

//MARK: - EXTENSION FOR RECIPES CELL -

extension BreakfastCell{
    
    fileprivate func configureRecipesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = receipesCollectionView.dequeueReusableCell(withReuseIdentifier: .recipesSubCell, for: indexPath) as! RecipesSubCell
        
        if isLoading{
            cell.showLoadingView()
            
        }else{
            
            cell.hideLoadingView()
            
            let recipe = self.arrayOfRecipes[indexPath.row]
            cell.titleLbl.text = recipe.name ?? ""
            if let url = URL(string: "\(UserDefault.shared.getMediaURL())\(recipe.image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: url)
            }
            cell.madeByLbl.text = "\(PisiffikStrings.by()): \(recipe.chef ?? "")"
            cell.servingLbl.text = "\(PisiffikStrings.portions()): \(recipe.servedPersons ?? 0)"
            cell.readyLbl.text = "\(PisiffikStrings.time()): \(recipe.preparationTime ?? "") \(PisiffikStrings.min())"
            
            if recipe.isFavorite == 0{
                cell.favoriteBtn.isSelected = false
            }else{
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.addTapGestureRecognizer { [weak self] in
                guard let self = self else {return}
                if let recipeID = self.arrayOfRecipes[indexPath.row].id {
                    self.delegate?.didTapOnRecipeFavoriteBtn(at: self.indexPath, id: recipeID)
                    if cell.favoriteBtn.isSelected{
                        cell.favoriteBtn.isSelected = false
                    }else{
                        cell.favoriteBtn.isSelected = true
                    }
                }
            }
            
        }
        
        return cell
    }
    
}
