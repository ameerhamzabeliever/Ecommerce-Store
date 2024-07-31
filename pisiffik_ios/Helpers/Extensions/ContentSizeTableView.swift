//
//  ContentSizeTableView.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension UITableView{
    
    func setEmptyDataSet(title: String = "",description: String = "",image: UIImage = UIImage(),buttonTitle: String = "",shouldDisplay: Bool,isScrollAllowed: Bool = true,action: @escaping () -> Void = {}){
        
        self.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: title))
                .detailLabelString(NSAttributedString(string: description))
                .image(image)
                .buttonTitle(NSAttributedString(string: buttonTitle), for: .normal)
                .dataSetBackgroundColor(.clear)
                .shouldDisplay(shouldDisplay)
                .verticalSpace(20.0)
                .shouldFadeIn(true)
                .isTouchAllowed(true)
                .isScrollAllowed(isScrollAllowed)
                .didTapDataButton {
                    action()
                }
        }
        
    }
    
}

extension UICollectionView{
    
    func setEmptyDataSet(title: String = "",description: String = "",image: UIImage = UIImage(),buttonTitle: String = "",shouldDisplay: Bool,isScrollAllowed: Bool = true,action: @escaping () -> Void = {}){
        
        self.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: title))
                .detailLabelString(NSAttributedString(string: description))
                .image(image)
                .buttonTitle(NSAttributedString(string: buttonTitle), for: .normal)
                .dataSetBackgroundColor(.clear)
                .shouldDisplay(shouldDisplay)
                .verticalSpace(20.0)
                .shouldFadeIn(true)
                .isTouchAllowed(true)
                .isScrollAllowed(isScrollAllowed)
                .didTapDataButton {
                    action()
                }
        }
        
    }
    
}


extension UITableView {

    func scrollToBottomRow() {
            DispatchQueue.main.async {
                guard self.numberOfSections > 0 else { return }

                // Make an attempt to use the bottom-most section with at least one row
                var section = max(self.numberOfSections - 1, 0)
                var row = max(self.numberOfRows(inSection: section) - 1, 0)
                var indexPath = IndexPath(row: row, section: section)

                // Ensure the index path is valid, otherwise use the section above (sections can
                // contain 0 rows which leads to an invalid index path)
                while !self.indexPathIsValid(indexPath) {
                    section = max(section - 1, 0)
                    row = max(self.numberOfRows(inSection: section) - 1, 0)
                    indexPath = IndexPath(row: row, section: section)

                    // If we're down to the last section, attempt to use the first row
                    if indexPath.section == 0 {
                        indexPath = IndexPath(row: 0, section: 0)
                        break
                    }
                }

                // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
                // exception here
                guard self.indexPathIsValid(indexPath) else { return }

                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
