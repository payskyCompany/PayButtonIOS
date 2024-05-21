//
//  GlobalManager.swift
//  PayButton
//
//  Created by Nada Kamel on 28/05/2023.
//  Copyright © 2023 Paysky. All rights reserved.
//

import UIKit

class GlobalManager: NSObject {
    static func setFont(_ size : CGFloat, isLight:Bool = false, isBold: Bool = false, isItalic:Bool = false) -> UIFont {
        if isBold {
//            return UIFont(name: "GESSTwoMedium-Medium", size: size)!
            return UIFont.systemFont(ofSize: size, weight: .bold)
        } else if isItalic {
//            return UIFont(name: "GESSTwoMedium-Medium", size: size)!
            return UIFont.italicSystemFont(ofSize: size)
        } else if isLight {
//            return UIFont(name: "GESSTwoLight-Light", size: size)!
            return UIFont.systemFont(ofSize: size, weight: .light)
        } else {
//            return UIFont(name: "GESSTwoMedium-Medium", size: size)!
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func cleanDollars(_ value: String?) -> String {
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
    
    //    static func compressImage(image: UIImage) -> UIImage {
    //        var actualHeight: CGFloat = image.size.height
    //        var actualWidth: CGFloat = image.size.width
    //        let maxHeight: CGFloat = 800.0
    //        //new max. height for image
    //        let maxWidth: CGFloat = 600.0
    //        //new max. width for image
    //        var imgRatio: CGFloat = actualWidth / actualHeight
    //        let maxRatio: CGFloat = maxWidth / maxHeight
    //        let compressionQuality: CGFloat = 0.5
    //        //0 percent compression
    //        if actualHeight > maxHeight || actualWidth > maxWidth {
    //            if imgRatio < maxRatio {
    //                //adjust width according to maxHeight
    //                imgRatio = maxHeight / actualHeight
    //                actualWidth = imgRatio * actualWidth
    //                actualHeight = maxHeight
    //            }
    //            else if imgRatio > maxRatio {
    //                //adjust height according to maxWidth
    //                imgRatio = maxWidth / actualWidth
    //                actualHeight = imgRatio * actualHeight
    //                actualWidth = maxWidth
    //            } else {
    //                actualHeight = maxHeight
    //                actualWidth = maxWidth
    //            }
    //        }
    //        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
    //        UIGraphicsBeginImageContext(rect.size)
    //        image.draw(in: rect)
    //        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    //        let imageData: NSData = img.jpegData(compressionQuality: compressionQuality)! as NSData
    //        UIGraphicsEndImageContext()
    //        return  UIImage(data: imageData as Data)!
    //    }
    
}
