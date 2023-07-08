//
//  MainViewController.swift
//  PayButton
//
//  Created by Nada Kamel on 07/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import MOLH
import UIKit

extension MainViewController: PayButtonDelegate {
    func finishedSdkPayment(_ response: PayByCardReponse) {
        if response.success == true {
            UIPasteboard.general.string = response.tokenCustomerId
            debugPrint("-------- Customer ID --------")
            debugPrint(response.tokenCustomerId ?? "")
            UIApplication.topViewController()?.view.makeToast("Transaction completed successfully and customer Id copied to clipboard")
        } else {
            UIApplication.topViewController()?.view.makeToast(response.message)
        }
    }
}

class MainViewController: UIViewController {
    @IBOutlet var versionLabel: UILabel!

    @IBOutlet var subscriptionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var selectChannelTextfield: UITextField!

    @IBOutlet var emailStackView: UIStackView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailTextfield: UITextField!

    @IBOutlet var mobileNumberStackView: UIStackView!
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var mobileNumberTextfield: UITextField!

    @IBOutlet var customerIdStackView: UIStackView!
    @IBOutlet var customerIdLabel: UILabel!
    @IBOutlet var customerIdTextfield: UITextField!

    @IBOutlet var merchantIdLabel: UILabel!
    @IBOutlet var merchantIdTextfield: UITextField!

    @IBOutlet var terminalIdLabel: UILabel!
    @IBOutlet var terminalIdTextfield: UITextField!

    @IBOutlet var secureHashKeyLabel: UILabel!
    @IBOutlet var secureHashKeyTextfield: UITextField!

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var amountTextfield: UITextField!

    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var currencyCodeTextfield: UITextField!

    @IBOutlet var trnxRefNumberLabel: UILabel!
    @IBOutlet var trnxRefNumberTextfield: UITextField!

    @IBOutlet var selectUrlLabel: UILabel!
    @IBOutlet var selectUrlEnvironmentPicker: UIPickerView!

    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!

    let selectChannelPickerView = UIPickerView()
    private let subscriptionTypes = ["mobile_number".localizedString(), "email_address".localizedString()]
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
            selectChannelTextfield.textAlignment = .left
            customerIdTextfield.textAlignment = .left
            mobileNumberTextfield.textAlignment = .left
            emailTextfield.textAlignment = .left
            merchantIdTextfield.textAlignment = .left
            terminalIdTextfield.textAlignment = .left
            secureHashKeyTextfield.textAlignment = .left
            amountTextfield.textAlignment = .left
            currencyCodeTextfield.textAlignment = .left
            trnxRefNumberTextfield.textAlignment = .left
            selectUrlLabel.text = "Select URL"
        } else {
            selectChannelTextfield.textAlignment = .right
            customerIdTextfield.textAlignment = .right
            mobileNumberTextfield.textAlignment = .right
            emailTextfield.textAlignment = .right
            merchantIdTextfield.textAlignment = .right
            terminalIdTextfield.textAlignment = .right
            secureHashKeyTextfield.textAlignment = .right
            amountTextfield.textAlignment = .right
            currencyCodeTextfield.textAlignment = .right
            trnxRefNumberTextfield.textAlignment = .right
            selectUrlLabel.text = "اختر الرابط"
        }
    }

    private func setupSubmitBtnUI() {
        if let channel = selectChannelTextfield.text, !channel.isEmpty {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = .mainColor
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = .lightGray
        }
        if let customerId = customerIdTextfield.text, !customerId.isEmpty {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = .mainColor
        } else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = .lightGray
        }
    }

    private func setupViewOutlets() {
        subscriptionTypeSegmentedControl.setTitle("not_subscribed".localizedString(), forSegmentAt: 0)
        subscriptionTypeSegmentedControl.setTitle("subscribed".localizedString(), forSegmentAt: 1)
        selectChannelTextfield.placeholder = "select_channel".localizedString()
        customerIdLabel.text = "customer_id".localizedString()
        mobileNumberLabel.text = "mobile_number".localizedString()
        emailLabel.text = "email".localizedString()
        merchantIdLabel.text = "merchantID".localizedString()
        terminalIdLabel.text = "terminalID".localizedString()
        secureHashKeyLabel.text = "secure_hash_key".localizedString()
        amountLabel.text = "amount".localizedString()
        currencyCodeLabel.text = "currency_code".localizedString()
        trnxRefNumberLabel.text = "ref_number".localizedString()
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        submitBtn.setTitle("submit".localizedString(), for: .normal)
        submitBtn.layer.cornerRadius = AppConstants.radiusNumber
        setupSubmitBtnUI()

        merchantIdTextfield.text = "41565"
        terminalIdTextfield.text = "1583826"
        secureHashKeyTextfield.text = "09a90e81140dcb0d686c09f0036ef910"
        amountTextfield.text = "10"
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

        let doneButton = UIBarButtonItem(title: "done".localizedString(), style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerValueUpdated))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        selectChannelTextfield.inputView = selectChannelPickerView
        selectChannelTextfield.inputAccessoryView = toolBar
    }

    @IBAction private func subscriptionTypeValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // Not subscribed
            selectChannelTextfield.isHidden = false
            customerIdStackView.isHidden = true
            pickerValueUpdated()
        } else { // Subscribed
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
        if Double(amount) == 0.0 {
            UIApplication.topViewController()?.view.makeToast("please_enter_amount_greater".localizedString())
            return
        }
        guard let currencyCode = currencyCodeTextfield.text, !currencyCode.isEmpty else {
            UIApplication.topViewController()?.view.makeToast("please_enter_currency_code".localizedString())
            return
        }

        // Check if "Not Subscribed" is selected
        if subscriptionTypeSegmentedControl.selectedSegmentIndex == 0 {
            guard let channel = selectChannelTextfield.text, !channel.isEmpty else {
                UIApplication.topViewController()?.view.makeToast("please_select_channel".localizedString())
                return
            }
            // Check if channel selected is "Mobile number" else "Email Address"
            if selectChannelPickerView.selectedRow(inComponent: 0) == 0 {
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
            } else {
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
        } else { // else "Subscribed" is selected
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
        if MOLHLanguage.currentAppleLanguage() == "en" {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }

        MOLH.reset()
        Bundle.swizzleLocalization()

        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - [Not Subscribed] Select Channel Textfield Accessory

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectChannelPickerView {
            return subscriptionTypes.count
        } else {
            return environmentTypes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectChannelPickerView {
            return subscriptionTypes[row]
        } else {
            return environmentTypes[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == selectUrlEnvironmentPicker {
            debugPrint(environmentTypes[row])
        }
    }

    @objc func pickerValueUpdated() {
        // if mobile number selected
        if selectChannelPickerView.selectedRow(inComponent: 0) == 0 {
            selectChannelTextfield.text = "mobile_channel_selected".localizedString()
            mobileNumberStackView.isHidden = false
            emailStackView.isHidden = true
        } else { // email address selected
            selectChannelTextfield.text = "email_channel_selected".localizedString()
            mobileNumberStackView.isHidden = true
            emailStackView.isHidden = false
        }
        setupSubmitBtnUI()
        selectChannelTextfield.resignFirstResponder()
    }
}
