//
//  MainViewController.swift
//  PayButton
//
//  Created by Nada Kamel on 07/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import MOLH

extension MainViewController: PayButtonDelegate {
    func finishedSdkPayment(_ transactionStatusResponse: TransactionStatusResponse, withCustomerId customerId: String) {
        if transactionStatusResponse.Success {
            UIPasteboard.general.string = customerId
            debugPrint("-------- Customer ID --------")
            debugPrint(customerId)
            UIApplication.topViewController()?.view.makeToast("Transaction completed successfully and customer Id copied to clipboard")
        } else {
            UIApplication.topViewController()?.view.makeToast("Transaction failed")
        }
    }
}

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
    
    @IBOutlet weak var trnxRefNumberLabel: UILabel!
    @IBOutlet weak var trnxRefNumberTextfield: UITextField!
    
    @IBOutlet weak var selectUrlLabel: UILabel!
    @IBOutlet weak var selectUrlEnvironmentPicker: UIPickerView!
    
    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    let selectChannelPickerView = UIPickerView()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewOutlets()
        
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
    }
    
    private func setupSubmitBtnUI() {
        if let channel = selectChannelTextfield.text, !channel.isEmpty {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = .mainBtnColor
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = .lightGray
        }
        if let customerId = customerIdTextfield.text, !customerId.isEmpty {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = .mainBtnColor
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = .lightGray
        }
    }
    
    private func setupViewOutlets() {
        merchantIdLabel.text = "merchantID".localizedString()
        terminalIdLabel.text = "terminalID".localizedString()
        amountLabel.text = "amount".localizedString()
        currencyCodeLabel.text = "currency_code".localizedString()
        secureHashKeyLabel.text = "secure_hash_key".localizedString()
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        submitBtn.setTitle("submit".localizedString(), for: .normal)
        submitBtn.layer.cornerRadius = AppConstants.radiusNumber
        setupSubmitBtnUI()
        
        merchantIdTextfield.text = "41565"
        terminalIdTextfield.text = "1583826"
        secureHashKeyTextfield.text = "09a90e81140dcb0d686c09f0036ef910"
        amountTextfield.text = "55.25"
        currencyCodeTextfield.text = "818"
        customerIdTextfield.text = "4cd7c612-7c13-44d0-b10c-21af9141b14c"
    }
    
    private func setupSelectUrlEnvironmentPickerView() {
        selectUrlEnvironmentPicker.delegate = self
        selectUrlEnvironmentPicker.dataSource = self
    }
    
    private func setupSelectChannelTextfieldPickerView() {
        selectChannelPickerView.backgroundColor = .white
        selectChannelPickerView.delegate = self
        selectChannelPickerView.dataSource = self
        
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

        selectChannelTextfield.inputView = selectChannelPickerView
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
        setupSubmitBtnUI()
    }
    
    @IBAction private func submitBtnPressed(_ sender: UIButton) {
        guard let merchantId = merchantIdTextfield.text, !merchantId.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_merchant".localizedString())
            return
        }
        guard let terminalId = terminalIdTextfield.text, !terminalId.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_terminal".localizedString())
            return
        }
        guard let secureHashKey = secureHashKeyTextfield.text, !secureHashKey.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_secure_hash_value".localizedString())
            return
        }
        guard let amount = amountTextfield.text, !amount.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_amount".localizedString())
            return
        }
        if(Double(amount) == 0.0) {
            UIApplication.topViewController()?.view.makeToast("please_enter_amount_greater".localizedString())
            return
        }
        guard let currencyCode = currencyCodeTextfield.text, !currencyCode.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_currency_code".localizedString())
            return
        }
        
        // Check if "Not Subscribed" is selected
        if(subscriptionTypeSegmentedControl.selectedSegmentIndex == 0) {
            guard let channel = selectChannelTextfield.text, !channel.isEmpty else {
                UIApplication.topViewController()?.view.makeToast("please_select_channel".localizedString())
                return
            }
            // Check if channel selected is "Mobile number" else "Email Address"
            if(selectChannelPickerView.selectedRow(inComponent: 0) == 0) {
                guard let mobileNumber = mobileNumberTextfield.text, !mobileNumber.isEmpty else {
                    UIApplication.topViewController()?.view.makeToast("please_enter_mobile_number".localizedString())
                    return
                }
                let paymentViewController = PaymentViewController(merchantId: merchantId,
                                                                  terminalId: terminalId,
                                                                  amount: Double(amount) ?? 0.00,
                                                                  currencyCode: Int(currencyCode) ?? AppConstants.selectedCountryCode,
                                                                  secureHashKey: secureHashKey,
                                                                  trnxRefNumber: trnxRefNumberTextfield.text ?? "",
                                                                  customerMobile: mobileNumber,
                                                                  isProduction: selectUrlEnvironmentPicker.selectedRow(inComponent: 0) == 0)
                paymentViewController.delegate = self
                paymentViewController.pushViewController()
            }
            else {
                guard let emailAddress = emailTextfield.text, !emailAddress.isEmpty else {
                    UIApplication.topViewController()?.view.makeToast("please_enter_your_mail".localizedString())
                    return
                }
                let paymentViewController = PaymentViewController(merchantId: merchantId,
                                                                  terminalId: terminalId,
                                                                  amount: Double(amount) ?? 0.00,
                                                                  currencyCode: Int(currencyCode) ?? AppConstants.selectedCountryCode,
                                                                  secureHashKey: secureHashKey,
                                                                  trnxRefNumber: trnxRefNumberTextfield.text ?? "",
                                                                  customerEmail: emailAddress,
                                                                  isProduction: selectUrlEnvironmentPicker.selectedRow(inComponent: 0) == 0)
                paymentViewController.delegate = self
                paymentViewController.pushViewController()
            }
        }
        else {      // else "Subscribed" is selected
            guard let customerId = customerIdTextfield.text, !customerId.isEmpty else {
                UIApplication.topViewController()?.view.makeToast("please_enter_customer_id".localizedString())
                return
            }
            let paymentViewController = PaymentViewController(merchantId: merchantId,
                                                              terminalId: terminalId,
                                                              amount: Double(amount) ?? 0.00,
                                                              currencyCode: Int(currencyCode) ?? AppConstants.selectedCountryCode,
                                                              secureHashKey: secureHashKey,
                                                              trnxRefNumber: trnxRefNumberTextfield.text ?? "",
                                                              customerId: customerId,
                                                              isProduction: selectUrlEnvironmentPicker.selectedRow(inComponent: 0) == 0)
            paymentViewController.delegate = self
            paymentViewController.pushViewController()
        }
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
        if(pickerView == selectChannelPickerView) {
            return subscriptionTypes.count
        } else {
            return environmentTypes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == selectChannelPickerView) {
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
        if(selectChannelPickerView.selectedRow(inComponent: 0) == 0) {
            selectChannelTextfield.text = "\(subscriptionTypes[0]) channel selected"
            mobileNumberStackView.isHidden = false
            emailStackView.isHidden = true
        } else {       // email address selected
            selectChannelTextfield.text = "\(subscriptionTypes[1]) channel selected"
            mobileNumberStackView.isHidden = true
            emailStackView.isHidden = false
        }
        setupSubmitBtnUI()
        selectChannelTextfield.resignFirstResponder()
    }
}
