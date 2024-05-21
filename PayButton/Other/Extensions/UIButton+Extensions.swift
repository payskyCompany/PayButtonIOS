//
//  UIButton+Extensions.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setButtonStyle(_ title:String ,
                        backgroundColor:UIColor,
                        cornerRadius:CGFloat,
                        borderWidth:CGFloat,
                        borderColor:UIColor,
                        font: UIFont,
                        textColor:UIColor,
                        paddingLeft:CGFloat? = 0.0,
                        paddingRight:CGFloat? = 0.0,
                        underline:Bool = false) {
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : font.italic,
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        let attributeString = NSMutableAttributedString(string: title,
                                                        attributes: yourAttributes)
        if underline {
            self.setAttributedTitle(attributeString, for: .normal)
        } else {
            self.setTitle(title, for: UIControl.State())
        }
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.setTitleColor(textColor, for: UIControl.State())
        self.titleLabel?.font =  font
//        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: paddingLeft!, bottom: 0.0, right: paddingRight!)
    }
}
