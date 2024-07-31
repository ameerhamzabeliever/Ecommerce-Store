//
//  KeyboardHandler.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 23/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardHandler: AnyObject {
    var bottomConstraint: NSLayoutConstraint! { get set }
    var replyTableView: UITableView! {get set}
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func startObservingKeyboardChanges()
    func stopObservingKeyboardChanges()
}


extension KeyboardHandler where Self: UIViewController {

    func startObservingKeyboardChanges() {

        // NotificationCenter observers
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
          self?.keyboardWillShow(notification)
        }

        // Deal with rotations
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
          self?.keyboardWillShow(notification)
        }

        // Deal with keyboard change (emoji, numerical, etc.)
        NotificationCenter.default.addObserver(forName: UITextInputMode.currentInputModeDidChangeNotification, object: nil, queue: nil) { [weak self] notification in
          self?.keyboardWillShow(notification)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
          self?.keyboardWillHide(notification)
        }
    }


    func keyboardWillShow(_ notification: Notification) {

      let verticalPadding: CGFloat = -15 // Padding between the bottom of the view and the top of the keyboard

        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
      let keyboardHeight = value.cgRectValue.height

      // Here you could have more complex rules, like checking if the textField currently selected is actually covered by the keyboard, but that's out of this scope.
      self.bottomConstraint.constant = keyboardHeight + verticalPadding
        self.replyTableView.scrollToBottomRow()

      UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.view.layoutIfNeeded()
      })
  }


  func keyboardWillHide(_ notification: Notification) {
      self.bottomConstraint.constant = 0
      self.replyTableView.scrollToBottomRow()
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.view.layoutIfNeeded()
      })
  }


  func stopObservingKeyboardChanges() {
      NotificationCenter.default.removeObserver(self)
  }
    
    
}
