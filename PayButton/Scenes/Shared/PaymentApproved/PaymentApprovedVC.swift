//
//  PaymentApprovedVC.swift
//  PayButton
//
//  Created by PaySky105 on 20/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import MOLH
import UIKit

protocol PaymentApprovedView: AnyObject {
    func setAuthCodeLabel(withText text: String)
    func setTransactionNoLabel(withText text: String)
    func startLoading()
    func endLoading()
    func didSendTrxnReceiptByEmail(withMessage message: String)
    func showErrorAlertView(withMessage errorMsg: String)
}

class PaymentApprovedVC: UIViewController {
    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .mainColor
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightText
        spinner.layer.cornerRadius = 20
        spinner.layer.masksToBounds = true
        return spinner
    }()
    
    @IBOutlet var closeCurrentPageBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var merchantLbl: UILabel!
    @IBOutlet var merchantNameLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountValueLbl: UILabel!

    @IBOutlet var enterCardDataLbl: UILabel!
    @IBOutlet var trxnApprovedLbl: UILabel!
    @IBOutlet var authCodeLbl: UILabel!
    @IBOutlet var authCodeValueLbl: UILabel!
    @IBOutlet var trxnNoLbl: UILabel!
    @IBOutlet var trxnNoValueLbl: UILabel!
    @IBOutlet var sendReceiptLbl: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var closeBtn: UIButton!

    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!

    var presenter: PaymentApprovedPresenter!

    weak var delegate: PayButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
        setupUIView()
        addSpinnerView()
    }
    
    private func addSpinnerView() {
        self.view.addSubview(loadingSpinner)
        loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    @IBAction func sendEmailBtnTapped(_ sender: UIButton) {
        emailTextField.endEditing(true)
        
        if (emailTextField.text?.isEmpty)! {
            UIApplication.topViewController()?.view.makeToast("please_enter_your_mail".localizedString()  )
            return
        }
        
        if !(emailTextField.text?.isValidEmail())! {
            UIApplication.topViewController()?.view.makeToast("please_enter_valid_mail".localizedString())
            return
        }
        
        presenter.sendEmail(emailTo: emailTextField.text ?? "",
                            externalReceiptNo: presenter.getPayByCardReponse().receiptNumber ?? "",
                            transactionChannel: presenter.getPayByCardReponse().fromWhere ?? "",
                            transactionId: String(presenter.getPayByCardReponse().systemReference ?? 0))
    }
    
    @IBAction func onCloseBtnTapped(_ sender: UIButton) {
        delegate?.finishedSdkPayment(presenter.getPayByCardReponse())
        if navigationController != nil {
            if let paymentVC = navigationController?.viewControllers.filter({ $0 is MainViewController }).first {
                navigationController?.popToViewController(paymentVC, animated: true)
            }
        }
    }

    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if MOLHLanguage.currentAppleLanguage() == "en" {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()

        let viewController = PaymentApprovedVC(nibName: "PaymentApprovedVC", bundle: nil)
        viewController.delegate = delegate
        let newPresenter = PaymentApprovedPresenter(view: viewController,
                                                    payByCardResponse: presenter.getPayByCardReponse())

        viewController.presenter = newPresenter
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.present(viewController, animated: true)
            })
        }
    }

    @IBAction func termsAndConditionsBtnPressed(_ sender: UIButton) {
    }
}

extension PaymentApprovedVC {
    private func setupUIView() {
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
            + " " + String(format: "%.2f", MerchantDataManager.shared.merchant.amount)

        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)

        enterCardDataLbl.text = "please_enter_card_data".localizedString()
        authCodeLbl.text = "auth_number".localizedString()
        trxnNoLbl.text = "trx_id".localizedString()
        sendReceiptLbl.text = "send_receipt".localizedString()
        emailTextField.placeholder = "email".localizedString()
        sendBtn.setTitle("send".localizedString(), for: .normal)
        closeBtn.setTitle("close".localizedString(), for: .normal)

        let string = "transaction_success".localizedString()
        let stringArr = string.components(separatedBy: " ")
        let myMutableString = NSMutableAttributedString(string: string, attributes: nil)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.hexStringToUIColor("#00BFA5"),
                                     range: NSRange(location: stringArr[0].count, length: stringArr[1].count + 1))
        trxnApprovedLbl.attributedText = myMutableString
    }
}

extension PaymentApprovedVC: PaymentApprovedView {
    func setAuthCodeLabel(withText text: String) {
        authCodeValueLbl.text = "#\(text)"
    }

    func setTransactionNoLabel(withText text: String) {
        trxnNoValueLbl.text = "#\(text)"
    }

    func startLoading() {
        sendBtn.isUserInteractionEnabled = false
        loadingSpinner.startAnimating()
    }

    func endLoading() {
        sendBtn.isUserInteractionEnabled = true
        loadingSpinner.stopAnimating()
    }
    
    func didSendTrxnReceiptByEmail(withMessage message: String) {
        endLoading()
        UIApplication.topViewController()?.view.makeToast(message)
    }
    
    func showErrorAlertView(withMessage errorMsg: String) {
        UIApplication.topViewController()?.showAlert("error".localizedString(), message: errorMsg)
    }
}
