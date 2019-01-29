//
//  Global.swift
//  Tab5Elsoltana
//
//  Created by Admin on 11/3/16.
//  Copyright © 2016 Raghda. All rights reserved.
//

import UIKit
import Alamofire
 

public  class PaySkySDKColor {

  public  static var mainBtnColor = Global.hexStringToUIColor("#00a7f6")
    
  public  static let RaduisNumber = CGFloat(4)

    
    
  public  static var fontColor = Global.hexStringToUIColor("#2C93C6")
 public   static var secondColorBtn = Global.hexStringToUIColor("#2C93C6")
  public  static var NavColor = Global.hexStringToUIColor("#00a7f6")

 //      static let NavColor = Global.hexStringToUIColor("#0F2A64")

    

}
class Global: NSObject {

    
    static func setFont (_ size : CGFloat, isLight:Bool = false, isBold: Bool = false, isItalic:Bool = false) -> UIFont {
        
        if isBold {
            return UIFont(name: "GESSTwoMedium-Medium", size: size)!
        } else if isItalic {
            return UIFont(name: "GESSTwoMedium-Medium", size: size)!
        } else if isLight {
            //return UIFont(name: "GESSTwoLight-Light", size: size)!
            return UIFont.systemFont(ofSize: size)

        } else {
          //  return UIFont(name: "GESSTwoMedium-Medium", size: size)!
            return UIFont.systemFont(ofSize: size)

        }
        //
        
        
    }
    
    
    static func compressImage(image: UIImage) -> UIImage {
        var actualHeight: CGFloat = image.size.height
        var actualWidth: CGFloat = image.size.width
        let maxHeight: CGFloat = 800.0
        //new max. height for image
        let maxWidth: CGFloat = 600.0
        //new max. width for image
        var imgRatio: CGFloat = actualWidth / actualHeight
        let maxRatio: CGFloat = maxWidth / maxHeight
        let compressionQuality: CGFloat = 0.5
        //0 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
                
                
            }else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData: NSData = img.jpegData(compressionQuality: compressionQuality)! as NSData
        UIGraphicsEndImageContext()
        return  UIImage(data: imageData as Data)!
    }
  static  func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
   

}

