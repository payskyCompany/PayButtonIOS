//
//  Extentions.swift
//  SnaPark
//
//  Created by Admin on 11/3/16.
//  Copyright © 2016 Raghda. All rights reserved.
//

//import Foundation
import UIKit
import ObjectiveC
 import PopupDialog

// Swift 3:


extension String {
    func localizedPaySky(bundle: Bundle = .main, tableName: String = "LocalizablePaySKy") -> String {
        var bandle :Bundle!
        
        
        
        let path = Bundle(for: BasePaymentViewController.self).path(forResource:"PayButton", ofType: "bundle")
        
        
        if path != nil {
            bandle = Bundle(path: path!) ?? Bundle.main
        }else {
            bandle = Bundle.main
            
        }
        
        
        return NSLocalizedString(self, tableName: tableName,bundle: bandle, value: "**\(self)**", comment: "")
    }
    
 
        public var replacedArabicDigitsWithEnglish: String {
            var str = self
            let map = ["٠": "0",
                       "١": "1",
                       "٢": "2",
                       "٣": "3",
                       "٤": "4",
                       "٥": "5",
                       "٦": "6",
                       "٧": "7",
                       "٨": "8",
                       "٩": "9"]
            map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
            return str
        }
     
}

public extension UITextField {
    
    /// SwifterSwift: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    public enum TextType {
        /// UITextField is used to enter email addresses.
        case emailAddress
        
        /// UITextField is used to enter passwords.
        case password
        
        /// UITextField is used to enter generic text.
        case generic
    }
    
}

// MARK: - Properties
public extension UITextField {
    
    /// SwifterSwift: Set textField for common text types.
    public var textType: TextType {
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
    
   


    

    
}

// MARK: - Methods
public extension UITextField {
    
    /// SwifterSwift: Clear text.
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    

    public func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
  
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    
    
    
}

extension UIViewController: UIAlertViewDelegate {
    
    /*var cancelHandler: (()->Void)? {
     get { return self.cancelHandler }
     set { }
     }*/
    
    func showAlert(_ title: String, message: String, okTitle: String = "OK",
                   okHandler: (()->Void)? = nil, cancelTitle: String = "", cancelHandler: (()->Void)? = nil ,showimage : Bool = true ,  image: UIImage = #imageLiteral(resourceName: "TransactionDeclined")) {
        //        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelTitle)
        //        alert.show()
        
        //        let popupVC = AlertViewController(nibName: "AlertViewController", bundle: nil)
        let popupVC = AlertDialogViewController(nibName: "AlertDialogViewController", bundle: nil)
        popupVC.titleText = title
        popupVC.messageText = message
        popupVC.okText = okTitle
        popupVC.cancelText = cancelTitle
        popupVC.imageMainParamter = image
        
               popupVC.showImage = showimage
        
        popupVC.okHandler = okHandler
        popupVC.cancelHandler = cancelHandler
        // Create the dialog
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 600, tapGestureDismissal: true)
        
        // Present dialog
        present(popup, animated: true, completion: nil)
        
        // self.cancelHandler = cancelHandler
        //let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //alert.addCancelAction(cancelTitle, cancelHandler: cancelHandler)
        
        //present(alert)
    }
    
}


extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}



extension UITextView {
    /// Resize the placeholder when the UITextView bounds change

    func setTextViewStyle(_ placholder:String, title:String,textColor:UIColor,font:UIFont,borderWidth:CGFloat,borderColor:UIColor,backgroundColor:UIColor,cornerRadius:CGFloat
        ,placeholderColor:UIColor, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0)  {
   
        

        self.contentInset = UIEdgeInsets.init(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)

//        self.attributedPlaceholder = myMutableStringTitle
//        self.text = "placholder".localizedPaySky()
//        self.placeholderText = "placholder".localizedPaySky()
        self.textColor =  UIColor.lightGray
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        self.attributedText = NSAttributedString(string: title, attributes: attributes)

        self.text = title
//        self.delegate =
        self.font = font
//        self.placholeder
        self.backgroundColor = backgroundColor
        self.layer.borderColor =  borderColor.cgColor
        self.layer.borderWidth =  borderWidth
        self.layer.cornerRadius = cornerRadius
    }
    

  
  
    
}



private var xoAssociationKey: UInt8 = 0

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


extension UIButton{
    
    func setButtonStyle(_ title:String ,backgroundColor:UIColor,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor,font: UIFont,textColor:UIColor, paddingLeft:CGFloat? = 0.0, paddingRight:CGFloat? = 0.0, underline:Bool = false) {
        
        
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
extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
} // extension

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
func cleanDollars(_ value: String?) -> String {
    guard value != nil else { return "$0.00" }
    let doubleValue = Double(value!) ?? 0.0
    let formatter = NumberFormatter()
    formatter.currencyCode = "USD"
    formatter.currencySymbol = ""
    formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
}

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        //let cKey = key.cString(using: String.Encoding.utf8)
        let hexkey = hexStringToBytes(key)
        
        
        let data = Data(bytes: hexkey!)
        let cKey = String(data: data, encoding: .utf8)
        
        
        
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        
        let datafroNS = Data(referencing: hmacData)
        //var hmacBase64 =  hmacData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //return String(hmacBase64)
        let hexSecureHash = datafroNS.hexEncodedString(options: .upperCase)
        return hexSecureHash
    }
}

func hexStringToBytes(_ string: String) -> [UInt8]? {
    let length = string.count
    if length & 1 != 0 {
        return nil
    }
    var bytes = [UInt8]()
    bytes.reserveCapacity(length/2)
    var index = string.startIndex
    for _ in 0..<length/2 {
        let nextIndex = string.index(index, offsetBy: 2)
        if let b = UInt8(string[index..<nextIndex], radix: 16) {
            bytes.append(b)
        } else {
            return nil
        }
        index = nextIndex
    }
    return bytes
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension UIView {
    
  
    
    func showLoadingIndicator() {
        self.makeToastActivity(ToastPosition.center)
        self.isUserInteractionEnabled = false
    }
    
    func hideLoadingIndicator() {
         self.hideToastActivity()
     self.isUserInteractionEnabled = true
    }
 
   


   
    
    

    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = PaySkySDKColor.RaduisNumber
        
    }
    

}




extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        
        return viewController
    }
}

extension String {
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}



