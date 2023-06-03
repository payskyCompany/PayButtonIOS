//
//  AlertDialogViewController.swift
//  PayButton
//
//  Created by AMR on 7/4/18.
//  Copyright © 2018 Paysky. All rights reserved.
//

import UIKit

class AlertDialogViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    var titleText = ""
    var messageText = ""
    var okText = "OK"
    var cancelText = ""
    var imageMainParamter = #imageLiteral(resourceName: "TransactionDeclined")

    var showImage = true
    var okHandler: (()->Void)? = nil
    var cancelHandler: (()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = AppConstants.radiusNumber
        
        titleLabel.text = titleText
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = GlobalManager.setFont(15)
        titleLabel.textColor = .white
        mainImage.image = imageMainParamter
        messageTextView.textColor =  UIColor.fontColor
        messageTextView.text = messageText
        messageTextView.font = GlobalManager.setFont(15, isLight: true)
        
        headerView.backgroundColor = UIColor.NavColor
        
        okButton.setButtonStyle(okText,
                                backgroundColor: UIColor.mainBtnColor,
                                cornerRadius: 5,
                                borderWidth: 0,
                                borderColor: .clear,
                                font: GlobalManager.setFont(15),
                                textColor: .white)
        if cancelText != "" {
            cancelButton.setButtonStyle(cancelText,
                                        backgroundColor: UIColor.secondColorBtn,
                                        cornerRadius: 5,
                                        borderWidth: 0,
                                        borderColor: .clear,
                                        font: GlobalManager.setFont(15),
                                        textColor: .white)
        } else {
            cancelButton.isHidden = true
        }
        
        if showImage {
            mainImage.isHidden = false
        } else {
            mainImage.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}



