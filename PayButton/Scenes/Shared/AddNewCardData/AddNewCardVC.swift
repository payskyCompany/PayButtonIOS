//
//  AddNewCardVC.swift
//  PayButton
//
//  Created by PaySky105 on 18/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import MOLH
import PayCardsRecognizer
import PopupDialog
import UIKit

protocol AddNewCardView: AnyObject {
    func hideSaveThisCardOutlets()
    func navigateToProcessingPaymentView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse)
    func showErrorAlertView(withMessage errorMsg: String)
    func startLoading()
    func endLoading()
}

class AddNewCardVC: UIViewController, MaskedTextFieldDelegateListener, ScanCardDelegate {
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

    @IBOutlet var proceedBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!

    @IBOutlet var cardNumberLogo: UIImageView!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cardHolderNameTF: UITextField!
    @IBOutlet var cardExpireDateTF: UITextField!
    @IBOutlet var cardCVVTF: UITextField!

    @IBOutlet var enterCardDataLbl: UILabel!
    @IBOutlet var scanCardBtn: UIButton!
    @IBOutlet var saveForFutureLbl: UILabel!
    @IBOutlet var saveForFutureCheckBox: CheckBox!
    @IBOutlet var setAsDefaultLbl: UILabel!
    @IBOutlet var setAsDefaultCheckBox: CheckBox!

    var maskedCreditCard: MaskedTextFieldDelegate!
    var maskedHolderName: MaskedTextFieldDelegate!
    var maskedCVV: MaskedTextFieldDelegate!

    var scanCreditCardDelegate: ScanCardDelegate?

    var cardNumber = ""
    let creditCardValidator = CreditCardValidator()
    var validCard = false

    var validExpiryDate = false
    var previousLength = 0
    var year = ""
    var month = ""

    var presenter: AddNewCardPresenter!

    weak var delegate: PayButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        presenter.viewDidLoad()
        setupUIView()
        addSpinnerView()
    }

    private func addSpinnerView() {
        view.addSubview(loadingSpinner)
        loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @IBAction func scanCardBtnTapped(_ sender: UIButton) {
        let st = UIStoryboard(name: "PayButtonBoard", bundle: nil)

        let vc: CardScanViewController = st.instantiateViewController(withIdentifier: "CardScanViewController") as! CardScanViewController
        vc.delegate = scanCreditCardDelegate
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }

    func cardResult(_ result: PayCardsRecognizerResult) {
        cardHolderNameTF.text = result.recognizedHolderName

        let mask: Mask = try! Mask(format: "[0000] [0000] [0000] [0000]")
        let input: String = result.recognizedNumber!
        let maskResult: Mask.Result = mask.apply(
            toText: CaretString(
                string: input,
                caretPosition: input.endIndex
            ),
            autocomplete: true
        )
        cardNumberTF.text = maskResult.formattedText.string

        textField(cardNumberTF, didFillMandatoryCharacters: true, didExtractValue: result.recognizedNumber ?? "")

        let data = (result.recognizedExpireDateMonth ?? "") + "/" + (result.recognizedExpireDateYear ?? "")
        let valueDate = (result.recognizedExpireDateMonth ?? "") + (result.recognizedExpireDateYear ?? "")

        cardExpireDateTF.text = data
        textField(cardExpireDateTF, didFillMandatoryCharacters: true, didExtractValue: valueDate)
    }

    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        textField.text = textField.text?.replacedArabicDigitsWithEnglish

        if textField.tag == 1 {
            checkCardNumberValid(value)

        } else if textField.tag == 2 {
            if value.count == 4 {
                year = String(value.replacedArabicDigitsWithEnglish.suffix(2))
                month = String(value.replacedArabicDigitsWithEnglish.prefix(2))

                if Int(year)! > 18 && Int(month)! < 13 {
                    validExpiryDate = true
                } else {
                    validExpiryDate = false
                }
            } else {
                validExpiryDate = false
            }
        }
    }

    @IBAction func cardExpireDateChanged(_ sender: UITextField) {
        validExpiryDate = false
        if previousLength > cardExpireDateTF.text!.count {
            previousLength = cardExpireDateTF.text!.count
            return
        }
        if cardExpireDateTF.text!.count == 1 && Int(cardExpireDateTF.text!)! > 2 {
            cardExpireDateTF.text! = "0" + cardExpireDateTF.text! + "/"
        }
        if cardExpireDateTF.text!.count == 2 && !cardExpireDateTF.text!.contains("/") {
            if Int(cardExpireDateTF.text!)! > 12 {
                cardExpireDateTF.text! = "12/"
            } else {
                cardExpireDateTF.text! = cardExpireDateTF.text! + "/"
            }
        }
        let val = cardExpireDateTF.text!.split(separator: "/")
        if cardExpireDateTF.text!.count == 5 && val.count > 1 {
            if Int(String(val[1] + ""))! > 19 {
                validExpiryDate = true
            } else {
                validExpiryDate = false
            }
        }

        previousLength = cardExpireDateTF.text!.count
    }

    @IBAction func saveForFutureBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            presenter.updateIsSaveCard(withValue: true)
        } else {
            presenter.updateIsSaveCard(withValue: false)

            setAsDefaultCheckBox.isChecked = false
            presenter.updateIsDefaultCard(withValue: false)
        }
    }

    @IBAction func setAsDefaultBtnAction(_ sender: CheckBox) {
        if !(sender.isChecked) {
            presenter.updateIsDefaultCard(withValue: true)

            saveForFutureCheckBox.isChecked = true
            presenter.updateIsSaveCard(withValue: true)
        } else {
            presenter.updateIsDefaultCard(withValue: false)
        }
    }

    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        UIApplication.topViewController()?.view.endEditing(true)

        #if DEBUG
            debugPrint("Not App Store or TestFlight build")
            validCard = true
        #else
            debugPrint("App Store or TestFlight build")
        #endif

        if isDataValid() {
            let expireDate = cardExpireDateTF.text!.split(separator: "/")
            let yearMonthFormat = expireDate[1] + expireDate[0]

            presenter.callPayByCardAPI(cardNumber: cardNumber,
                                       cardHolderName: cardHolderNameTF.text ?? "",
                                       expiryDate: String(yearMonthFormat),
                                       cvv: cardCVVTF.text ?? "")
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

        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = delegate
        let newPresenter = AddNewCardPresenter(view: viewController,
                                               paymentMethodData: presenter.getPaymentMethodData())
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

extension AddNewCardVC {
    private func setupUIView() {
        hideSaveThisCardOutlets()

        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = presenter.getPaymentMethodData().merchantName
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
            + " " + String(format: "%.2f", MerchantDataManager.shared.merchant.amount)

        proceedBtn.setTitle("proceed".localizedString(), for: .normal)
        backBtn.setTitle("back".localizedString(), for: .normal)
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)

        enterCardDataLbl.text = "please_enter_card_data".localizedString()
        saveForFutureLbl.text = "save_for_future_use".localizedString()
        setAsDefaultLbl.text = "set_as_default".localizedString()
        scanCardBtn.setTitle("", for: .normal)
        saveForFutureCheckBox.setTitle("", for: .normal)
        setAsDefaultCheckBox.setTitle("", for: .normal)

        cardNumberTF.setTextFieldStyle("card_number".localizedString(), title: "", textColor: UIColor.black, font: GlobalManager.setFont(14), borderWidth: 0, borderColor: UIColor.clear, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray, maxLength: 18, padding: 10)

        cardHolderNameTF.setTextFieldStyle("name_on_card".localizedString(), title: "", textColor: UIColor.black, font: GlobalManager.setFont(14), borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray, maxLength: 10, padding: 10, keyboardType: UIKeyboardType.default)

        cardExpireDateTF.setTextFieldStyle("expire_date".localizedString(), title: "", textColor: UIColor.black, font: GlobalManager.setFont(14), borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray, maxLength: 5, padding: 10)

        cardCVVTF.setTextFieldStyle("cvc".localizedString(), title: "", textColor: UIColor.black, font: GlobalManager.setFont(14), borderWidth: 0, borderColor: UIColor.gray, backgroundColor: UIColor.white, cornerRadius: 0, placeholderColor: UIColor.gray, maxLength: 4, padding: 4)

        maskedCreditCard = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
        maskedCreditCard.listener = self
        cardNumberTF.delegate = maskedCreditCard
        cardNumberTF.tag = 1

        maskedHolderName = MaskedTextFieldDelegate(primaryFormat: "[A][--------] [A][---------] [A][---------]")
        cardHolderNameTF.delegate = maskedHolderName
        maskedHolderName.listener = self

        maskedCVV = MaskedTextFieldDelegate(primaryFormat: "[000]")
        maskedCVV.listener = self
        cardCVVTF.delegate = maskedCVV

        cardExpireDateTF.tag = 2
        scanCreditCardDelegate = self
    }
}

extension AddNewCardVC: AddNewCardView {
    func hideSaveThisCardOutlets() {
        saveForFutureCheckBox.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        saveForFutureLbl.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        setAsDefaultCheckBox.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
        setAsDefaultLbl.isHidden = !(presenter.getPaymentMethodData().isTokenized ?? false)
    }

    func navigateToProcessingPaymentView(withUrlPath path: String) {
        let viewController = PaymentProcessingVC(nibName: "PaymentProcessingVC", bundle: nil)
        viewController.delegate = delegate

        let presenter = PaymentProcessingPresenter(view: viewController,
                                                   paymentMethodData: presenter.getPaymentMethodData(),
                                                   urlPath: path)
        viewController.presenter = presenter

        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }

    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse) {
        let viewController = PaymentApprovedVC(nibName: "PaymentApprovedVC", bundle: nil)
        viewController.delegate = delegate

        let presenter = PaymentApprovedPresenter(view: viewController,
                                                 paymentMethodData: presenter.getPaymentMethodData(),
                                                 payByCardResponse: response)
        viewController.presenter = presenter

        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }

    func showErrorAlertView(withMessage errorMsg: String) {
        proceedBtn.isUserInteractionEnabled = true
        UIApplication.topViewController()?.showAlert("error".localizedString(), message: errorMsg)
    }

    func startLoading() {
        proceedBtn.isUserInteractionEnabled = false
        loadingSpinner.startAnimating()
    }

    func endLoading() {
        proceedBtn.isUserInteractionEnabled = true
        loadingSpinner.stopAnimating()
    }
}
