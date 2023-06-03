//
//  UITextView+Extensions.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// Resize the placeholder when the UITextView bounds change
    func setTextViewStyle(_ placholder: String,
                          title: String,
                          textColor: UIColor,
                          font: UIFont,
                          borderWidth: CGFloat,
                          borderColor: UIColor,
                          backgroundColor: UIColor,
                          cornerRadius: CGFloat,
                          placeholderColor: UIColor,
                          paddingLeft: CGFloat = 0,
                          paddingRight: CGFloat = 0) {
        self.contentInset = UIEdgeInsets.init(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
//        self.attributedPlaceholder = myMutableStringTitle
//        self.text = "placholder".localizedString()
//        self.placeholderText = "placholder".localizedString()
        self.textColor =  UIColor.lightGray
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        self.attributedText = NSAttributedString(string: title, attributes: attributes)

        self.text = title
        self.font = font
        self.backgroundColor = backgroundColor
        self.layer.borderColor =  borderColor.cgColor
        self.layer.borderWidth =  borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}
