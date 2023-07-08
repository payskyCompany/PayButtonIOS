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
    func setSuccessMessageLabel(withText text: String)
    func setReferenceNoLabel(withText text: String)
}

class PaymentApprovedVC: UIViewController {
    @IBOutlet var closeCurrentPageBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var merchantLbl: UILabel!
    @IBOutlet var merchantNameLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountValueLbl: UILabel!

    @IBOutlet var enterCardDataLbl: UILabel!
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
    }

    @IBAction func onCloseBtnTapped(_ sender: UIButton) {
        delegate?.finishedSdkPayment(presenter.getPayByCardReponse())
        if navigationController != nil {
            if let paymentVC = navigationController?.viewControllers.filter({ $0 is MainViewController }).first {
                navigationController?.popToViewController(paymentVC, animated: true)
            }
        }
    }

    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        dismiss(animated: true)
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
    }
}

extension PaymentApprovedVC: PaymentApprovedView {
    func setSuccessMessageLabel(withText text: String) {
//        _view.successMessageLabel.text = text
    }

    func setReferenceNoLabel(withText text: String) {
//        if let label = _view.referenceNoLabel.text {
//            _view.referenceNoLabel.text = "\(label) \(text)"
//        }
    }
}
