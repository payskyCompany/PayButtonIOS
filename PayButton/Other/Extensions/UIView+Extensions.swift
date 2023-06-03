//
//  UIView+Extensions.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit

extension UIView {
    
    func showLoadingIndicator() {
        self.makeToastActivity(ToastPosition.center)
        self.isUserInteractionEnabled = false
    }
    
    func hideLoadingIndicator() {
         self.hideToastActivity()
        self.isUserInteractionEnabled = true
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = AppConstants.radiusNumber
    }
}
