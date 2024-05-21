//
//  UIViewController+Extension.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit
import PopupDialog

// MARK: - Hide keyboard when tapping around

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIAlertViewDelegate for PopupDialog
extension UIViewController: UIAlertViewDelegate {

    func showAlert(_ title: String,
                   message: String,
                   okTitle: String = "OK",
                   okHandler: (()->Void)? = nil,
                   cancelTitle: String = "",
                   cancelHandler: (()->Void)? = nil,
                   showImage : Bool = true,
                   image: UIImage = #imageLiteral(resourceName: "TransactionDeclined")) {
        let popupVC = AlertDialogViewController(nibName: "AlertDialogViewController", bundle: nil)
        popupVC.titleText = title
        popupVC.messageText = message
        popupVC.okText = okTitle
        popupVC.cancelText = cancelTitle
        popupVC.imageMainParamter = image
        popupVC.showImage = showImage
        popupVC.okHandler = okHandler
        popupVC.cancelHandler = cancelHandler
        
        // Create the dialog
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 600, tapGestureDismissal: true)
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
}
