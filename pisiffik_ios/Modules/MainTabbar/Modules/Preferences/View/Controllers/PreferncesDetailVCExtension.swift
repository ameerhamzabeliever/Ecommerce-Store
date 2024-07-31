//
//  PreferncesDetailVCExtension.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

//MARK: - EXTENSION FOR LIST VIEW METHODS -

extension PreferencesDetailVC: ListViewMethods{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 10 : isSearching ? searchingList.count : arrayOfSubCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1
        }else if isSearching{
            if self.searchingList[section].isOpen == false{
                return 1
            }else{
                return (self.searchingList[section].subCategory.child?.count ?? 0) + 1
            }
        }else{
            if self.arrayOfSubCategories[section].isOpen == false{
                return 1
            }else{
                return (self.arrayOfSubCategories[section].subCategory.child?.count ?? 0) + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            return configureCategorySearchTableCell(at: indexPath)
        }else{
            return configureCategoryTableCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading {return}
        if indexPath.row == 0{
            if isSearching{
                if self.searchingList[indexPath.section].isOpen{
                    self.searchingList[indexPath.section].isOpen = false
                    self.categoryTableView.reloadSections([indexPath.section], with: .none)
                }else{
                    self.searchingList[indexPath.section].isOpen = true
                    self.categoryTableView.reloadSections([indexPath.section], with: .none)
                }
            }else{
                if self.arrayOfSubCategories[indexPath.section].isOpen{
                    self.arrayOfSubCategories[indexPath.section].isOpen = false
                    self.categoryTableView.reloadSections([indexPath.section], with: .none)
                }else{
                    self.arrayOfSubCategories[indexPath.section].isOpen = true
                    self.categoryTableView.reloadSections([indexPath.section], with: .none)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


//MARK: - EXTENSION FOR CATEGORY TABLE VIEW CELL -

extension PreferencesDetailVC{
    
    private func configureCategoryTableCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: .preferencesDataCell, for: indexPath) as! PreferencesDataCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            if indexPath.row == 0{
                cell.titleLbl.text = self.arrayOfSubCategories[indexPath.section].subCategory.name
                cell.titleLbl.font = Fonts.mediumFontsSize14
                cell.titleLbl.textColor = R.color.textBlackColor()
                cell.dropDownImageView.isHidden = false
                cell.verticalSeperatorView.isHidden = false
                cell.horizontalSeperatorView.isHidden = false
            }else{
                cell.titleLbl.text = self.arrayOfSubCategories[indexPath.section].subCategory.child?[indexPath.row - 1].name
                cell.titleLbl.font = Fonts.regularFontsSize14
                cell.titleLbl.textColor = R.color.textGrayColor()
                cell.dropDownImageView.isHidden = true
                cell.verticalSeperatorView.isHidden = true
                if indexPath.row == (self.arrayOfSubCategories[indexPath.section].subCategory.child?.count){
                    cell.horizontalSeperatorView.isHidden = false
                }else{
                    cell.horizontalSeperatorView.isHidden = true
                }
            }
            
            
            if self.arrayOfSubCategories[indexPath.section].isOpen{
                cell.dropDownImageView.image = R.image.ic_preferences_up()
            }else{
                cell.dropDownImageView.image = R.image.ic_preferences_down()
            }
            
            cell.checkBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    self?.removeSubCategoryID(row: indexPath.row, section: indexPath.section)
                    self?.updateArrayOfCategoryID(at: indexPath)
                    self?.updateSubCategoryIsPrefered(section: indexPath.section, row: indexPath.row)
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
            
            if indexPath.row == 0{
                if self.arrayOfCategoryID.contains(where: {$0 == self.arrayOfSubCategories[indexPath.section].subCategory.id}){
                    cell.checkBtn.isSelected = true
                }else{
                    cell.checkBtn.isSelected = false
                }
            }else{
                if self.arrayOfCategoryID.contains(where: {$0 == self.arrayOfSubCategories[indexPath.section].subCategory.child?[indexPath.row - 1].id}){
                    cell.checkBtn.isSelected = true
                }else{
                    cell.checkBtn.isSelected = false
                }
            }
            
        }
        
        return cell
    }
    
    
    private func configureCategorySearchTableCell(at indexPath: IndexPath) -> UITableViewCell{
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: .preferencesDataCell, for: indexPath) as! PreferencesDataCell
        
        if isLoading{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            if indexPath.row == 0{
                cell.titleLbl.text = self.searchingList[indexPath.section].subCategory.name
                cell.titleLbl.font = Fonts.mediumFontsSize14
                cell.titleLbl.textColor = R.color.textBlackColor()
                cell.dropDownImageView.isHidden = false
                cell.verticalSeperatorView.isHidden = false
                cell.horizontalSeperatorView.isHidden = false
            }else{
                cell.titleLbl.text = self.searchingList[indexPath.section].subCategory.child?[indexPath.row - 1].name
                cell.titleLbl.font = Fonts.regularFontsSize14
                cell.titleLbl.textColor = R.color.textGrayColor()
                cell.dropDownImageView.isHidden = true
                cell.verticalSeperatorView.isHidden = true
                if indexPath.row == (self.searchingList[indexPath.section].subCategory.child?.count){
                    cell.horizontalSeperatorView.isHidden = false
                }else{
                    cell.horizontalSeperatorView.isHidden = true
                }
            }
            
            
            if self.searchingList[indexPath.section].isOpen{
                cell.dropDownImageView.image = R.image.ic_preferences_up()
            }else{
                cell.dropDownImageView.image = R.image.ic_preferences_down()
            }
            
            cell.checkBtn.addTapGestureRecognizer { [weak self] in
                if Network.isAvailable{
                    self?.removeSubCategoryID(row: indexPath.row, section: indexPath.section)
                    self?.updateSearchingArrayOfCategoryID(at: indexPath)
                    self?.updateSearchSubCategoryIsPrefered(section: indexPath.section, row: indexPath.row)
                }else{
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
                }
            }
            
            
            if indexPath.row == 0{
                if self.arrayOfCategoryID.contains(where: {$0 == self.searchingList[indexPath.section].subCategory.id}){
                    cell.checkBtn.isSelected = true
                }else{
                    cell.checkBtn.isSelected = false
                }
            }else{
                if self.arrayOfCategoryID.contains(where: {$0 == self.searchingList[indexPath.section].subCategory.child?[indexPath.row - 1].id}){
                    cell.checkBtn.isSelected = true
                }else{
                    cell.checkBtn.isSelected = false
                }
            }
            
        }
        
        return cell
    }
    
    
}


//MARK: - EXTENSION FOR COLLECTION VIEW METHODS -

extension PreferencesDetailVC: CollectionViewMethods{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoading && self.arrayOfMainCategories.isEmpty ? 7 : arrayOfMainCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCategoriesCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading && isSearching {return}
        if !isLoading{
            self.didGetCategoryData(at: indexPath)
        }
        self.categoryCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        self.categoryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.categoryCollectionView.frame.size
        return CGSize(width: (size.width - 5), height: 100.0)
    }
    
}


//MARK: - EXTENSION FOR CATEGORIES CELL -

extension PreferencesDetailVC{
    
    private func configureCategoriesCell(at indexPath: IndexPath) -> UICollectionViewCell{
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: .categoriesCell, for: indexPath) as! CategoriesCell
        
        if isLoading && self.arrayOfMainCategories.isEmpty{
            cell.setSkeletonView()
            
        }else{
            cell.hideSkeletonView()
            
            cell.itemNameLbl.text = arrayOfMainCategories[indexPath.row].name
            
            if let imageURL = URL(string: "\(UserDefault.shared.getMediaURL())\(arrayOfMainCategories[indexPath.row].image ?? "")"){
                cell.itemImageView.kf.indicatorType = .activity
                cell.itemImageView.kf.setImage(with: imageURL)
                cell.itemImageView.image = cell.itemImageView.image?.withRenderingMode(.alwaysTemplate)
            }
            
            if arrayOfCategoryID.contains(where: {$0 == arrayOfMainCategories[indexPath.row].id}){
                cell.itemImageView.tintColor = R.color.darkBlueColor()
                cell.itemNameLbl.textColor = R.color.textBlueColor()
            }else{
                cell.itemImageView.tintColor = R.color.darkGrayColor()
                cell.itemNameLbl.textColor = R.color.textGrayColor()
            }
            
            if self.currentCategoryIndex == indexPath.row{
                cell.backView.backgroundColor = .white
            }else{
                cell.backView.backgroundColor = .clear
            }
            
        }
        
        return cell
    }
    
}


extension PreferencesDetailVC{
    
    func getCategoryRequest(id: Int) -> RemoveCategoryRequest{
        var request = RemoveCategoryRequest()
        request.categoryID = id
        return request
    }
    
}
