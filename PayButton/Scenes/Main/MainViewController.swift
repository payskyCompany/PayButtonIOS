//
//  MainViewController.swift
//  PayButton
//
//  Created by Nada Kamel on 07/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import MOLH

class MainViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var subscriptionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var selectChannelTextfield: UITextField!
    
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var mobileNumberStackView: UIStackView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    
    @IBOutlet weak var customerIdStackView: UIStackView!
    @IBOutlet weak var customerIdLabel: UILabel!
    @IBOutlet weak var customerIdTextfield: UITextField!
    
    @IBOutlet weak var merchantIdLabel: UILabel!
    @IBOutlet weak var merchantIdTextfield: UITextField!
    
    @IBOutlet weak var terminalIdLabel: UILabel!
    @IBOutlet weak var terminalIdTextfield: UITextField!
    
    @IBOutlet weak var secureHashKeyLabel: UILabel!
    @IBOutlet weak var secureHashKeyTextfield: UITextField!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyCodeTextfield: UITextField!
    
    @IBOutlet weak var selectUrlLabel: UILabel!
    @IBOutlet weak var selectUrlEnvironmentPicker: UIPickerView!
    
    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    let selectChannelpickerView = UIPickerView()
    private let subscriptionTypes = ["Mobile number", "Email address"]
    private let environmentTypes = ["Production", "Testing"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        versionLabel.text = (versionLabel.text ?? "") + "\(Bundle.main.releaseVersionNumber ?? "")"
        
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        subscriptionTypeSegmentedControl.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        subscriptionTypeSegmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        setupSelectUrlEnvironmentPickerView()
        
        setupSelectChannelTextfieldPickerView()
        emailStackView.isHidden = true
        mobileNumberStackView.isHidden = true
        customerIdStackView.isHidden = true
        
        setupViewOutlets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if MOLHLanguage.currentAppleLanguage() != "ar" {
            merchantIdTextfield.textAlignment = .left
            terminalIdTextfield.textAlignment = .left
            secureHashKeyTextfield.textAlignment = .left
            amountTextfield.textAlignment = .left
            currencyCodeTextfield.textAlignment = .left
            selectUrlLabel.text = "Select URL"
        }
        else {
            merchantIdTextfield.textAlignment = .right
            terminalIdTextfield.textAlignment = .right
            secureHashKeyTextfield.textAlignment = .right
            amountTextfield.textAlignment = .right
            currencyCodeTextfield.textAlignment = .right
            selectUrlLabel.text = "اختر الرابط"
        }
        merchantIdLabel.text = "merchantID".localizedString()
        terminalIdLabel.text = "terminalID".localizedString()
        secureHashKeyLabel.text = "secure_hash_key".localizedString()
        amountLabel.text = "amount".localizedString()
        currencyCodeLabel.text = "currency_code".localizedString()
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        submitBtn.setTitle("pay_now".localizedString(), for: .normal)
    }
    
    private func setupViewOutlets() {
        merchantIdLabel.text = "merchantID".localizedString()
        merchantIdTextfield.setTextFieldStyle("merchantID".localizedString(),
                                              title: "",
                                              textColor: UIColor.black,
                                              font:GlobalManager.setFont(14),
                                              borderWidth: 1,
                                              borderColor: UIColor.gray,
                                              backgroundColor: UIColor.white,
                                              cornerRadius: AppConstants.radiusNumber,
                                              placeholderColor: UIColor.gray,
                                              maxLength: 20,
                                              padding: 5,
                                              keyboardType: .numberPad)

       terminalIdLabel.text =  "terminalID".localizedString()
       terminalIdTextfield.setTextFieldStyle("terminalID".localizedString(),
                                             title: "",
                                             textColor: UIColor.black,
                                             font:GlobalManager.setFont(14),
                                             borderWidth: 1,
                                             borderColor: UIColor.gray,
                                             backgroundColor: UIColor.white,
                                             cornerRadius: AppConstants.radiusNumber,
                                             placeholderColor: UIColor.gray,
                                             maxLength: 20,
                                             padding: 5,
                                             keyboardType: .numberPad)
       
       amountLabel.text = "amount".localizedString()
       amountTextfield.setTextFieldStyle("amount".localizedString(),
                                         title: "",
                                         textColor: UIColor.black,
                                         font:GlobalManager.setFont(14),
                                         borderWidth: 1,
                                         borderColor: UIColor.gray,
                                         backgroundColor: UIColor.white,
                                         cornerRadius: AppConstants.radiusNumber,
                                         placeholderColor: UIColor.gray,
                                         maxLength: 10,
                                         padding: 5,
                                         keyboardType: .decimalPad)
        
        currencyCodeLabel.text = "currency_code".localizedString()
        currencyCodeTextfield.setTextFieldStyle("currency_code".localizedString(),
                                                title: "",
                                                textColor: UIColor.black,
                                                font:GlobalManager.setFont(14),
                                                borderWidth: 1,
                                                borderColor: UIColor.gray,
                                                backgroundColor: UIColor.white,
                                                cornerRadius: AppConstants.radiusNumber,
                                                placeholderColor: UIColor.gray,
                                                maxLength: 10,
                                                padding: 5,
                                                keyboardType: .numberPad)
        
        secureHashKeyLabel.text = "secure_hash_key".localizedString()
        secureHashKeyTextfield.setTextFieldStyle("secure_hash_key".localizedString(),
                                                 title: "",
                                                 textColor: UIColor.black,
                                                 font:GlobalManager.setFont(14),
                                                 borderWidth: 1,
                                                 borderColor: UIColor.gray,
                                                 backgroundColor: UIColor.white,
                                                 cornerRadius: AppConstants.radiusNumber,
                                                 placeholderColor: UIColor.gray,
                                                 maxLength: 100,
                                                 padding: 5,
                                                 keyboardType: .alphabet)
        
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        submitBtn.setTitle("submit".localizedString(), for: .normal)
        submitBtn.layer.cornerRadius = AppConstants.radiusNumber
    }
    
    private func setupSelectUrlEnvironmentPickerView() {
        selectUrlEnvironmentPicker.delegate = self
        selectUrlEnvironmentPicker.dataSource = self
    }
    
    private func setupSelectChannelTextfieldPickerView() {
        selectChannelpickerView.backgroundColor = .white
        selectChannelpickerView.delegate = self
        selectChannelpickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.pickerValueUpdated))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.pickerValueUpdated))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        selectChannelTextfield.inputView = selectChannelpickerView
        selectChannelTextfield.inputAccessoryView = toolBar
    }

    @IBAction private func subscriptionTypeValueChanged(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {      // Not subscribed
            selectChannelTextfield.isHidden = false
            customerIdStackView.isHidden = true
            pickerValueUpdated()
        } else {                                    // Subscribed
            selectChannelTextfield.isHidden = true
            mobileNumberStackView.isHidden = true
            emailStackView.isHidden = true
            customerIdStackView.isHidden = false
        }
    }
    
    @IBAction private func submitBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction private func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if (MOLHLanguage.currentAppleLanguage() == "en") {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        
        MOLH.reset()
        Bundle.swizzleLocalization()
        
        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(viewController, animated: true,completion: nil)
    }
    
    
}

// MARK: - [Not Subscribed] Select Channel Textfield Accessory
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == selectChannelpickerView) {
            return subscriptionTypes.count
        } else {
            return environmentTypes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == selectChannelpickerView) {
            return subscriptionTypes[row]
        } else {
            return environmentTypes[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == selectUrlEnvironmentPicker) {
            debugPrint(environmentTypes[row])
        }
    }
    
    @objc func pickerValueUpdated() {
        // if mobile number selected
        if(selectChannelpickerView.selectedRow(inComponent: 0) == 0) {
            selectChannelTextfield.text = "\(subscriptionTypes[0]) channel selected"
            mobileNumberStackView.isHidden = false
            emailStackView.isHidden = true
        } else {       // email address selected
            selectChannelTextfield.text = "\(subscriptionTypes[1]) channel selected"
            mobileNumberStackView.isHidden = true
            emailStackView.isHidden = false
        }
        selectChannelTextfield.resignFirstResponder()
    }
}
