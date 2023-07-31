//
//  UITextField+Extensions.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit

public extension UITextField {
    
    /// SwifterSwift: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    enum TextType {
        /// UITextField is used to enter email addresses.
        case emailAddress
        
        /// UITextField is used to enter passwords.
        case password
        
        /// UITextField is used to enter generic text.
        case generic
    }
    
    /// SwifterSwift: Set textField for common text types.
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                placeholder = "Email Address"
                
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                placeholder = "Password"
                
            case .generic:
                isSecureTextEntry = false
            }
        }
    }

    /// SwifterSwift: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// SwifterSwift: addPaddingLeft.
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
  
    /// SwifterSwift: addPaddingLeftIcon.
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextField.ViewMode.always
    }
}

private var xoAssociationKey: UInt8 = 0

// MARK: - UITextFieldDelegate
extension UITextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.maxLength != 0 && textField.maxLength != nil {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= textField.maxLength
        } else {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 50
        }
    }
    
    var maxLength: Int! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Int
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setTextFieldStyle(_ placholder:String, title:String,textColor:UIColor,font:UIFont,borderWidth:CGFloat,borderColor:UIColor,backgroundColor:UIColor,cornerRadius:CGFloat,placeholderColor:UIColor, maxLength: Int = 0, padding: CGFloat = 10
        , keyboardType: UIKeyboardType = .numberPad)  {
        
        var myMutableStringTitle = NSMutableAttributedString()
        
        myMutableStringTitle = NSMutableAttributedString(string: placholder, attributes: [NSAttributedString.Key.font:font]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: placeholderColor, range:NSRange(location:0, length: placholder.count))    // Color
        
        
        self.attributedPlaceholder = myMutableStringTitle
        self.text = title
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.layer.borderColor =  borderColor.cgColor
        self.layer.borderWidth =  borderWidth
        self.layer.cornerRadius = cornerRadius
        self.maxLength = maxLength
        self.delegate = self
        self.keyboardType = keyboardType
        self.addPaddingLeft(padding)
    }
}
