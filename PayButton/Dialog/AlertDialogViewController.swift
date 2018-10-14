//
//  AlertDialogViewController.swift
//  tokenization
//
//  Created by AMR on 7/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class AlertDialogViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var MainImage: UIImageView!
    
    var titleText = ""
    var messageText = ""
    var okText = "OK"
    var cancelText = ""
    var imageMainParamter = #imageLiteral(resourceName: "TransactionDeclined")

    var showImage = true
    var okHandler: (()->Void)? = nil
    var cancelHandler: (()->Void)? = nil
    
    
    
    
    
    
    
    @IBOutlet weak var HeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        messageTextView.setTextViewStyle("", title: messageText, textColor: Colors.fontColor, font: Global.setFont(15), borderWidth: 0, borderColor: .clear, backgroundColor: .clear, cornerRadius: 0, placeholderColor: .clear)
        titleLabel.text = titleText
        titleLabel.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        titleLabel.numberOfLines = 0
        titleLabel.font = Global.setFont(15)
        titleLabel.textColor = .white
        MainImage.image = imageMainParamter
        messageTextView.textColor =  PaySkySDKColor.fontColor
        messageTextView.text = messageText
        messageTextView.font = Global.setFont(15, isLight: true)
        
        HeaderView.backgroundColor = PaySkySDKColor.NavColor
        
        //        messageTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        //        messageTextView.setContentOffset(CGPoint.zero, animated: false)
        
        okButton.setButtonStyle(okText, backgroundColor: PaySkySDKColor.mainBtnColor, cornerRadius: 5, borderWidth: 0, borderColor: .clear, font: Global.setFont(15), textColor: .white)
        if cancelText != "" {

        cancelButton.setButtonStyle(cancelText, backgroundColor: PaySkySDKColor.secondColorBtn, cornerRadius: 5, borderWidth: 0, borderColor: .clear, font: Global.setFont(15), textColor: .white)
        }else{
            cancelButton.isHidden = true

        }
        
        if showImage {
            MainImage.isHidden = false
        }else{
            MainImage.isHidden = true

        }
        
        self.view.layer.cornerRadius = PaySkySDKColor.RaduisNumber
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func okAction(_ sender: Any) {
        if okHandler == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            okHandler!()
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        if cancelHandler == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            cancelHandler!()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}



