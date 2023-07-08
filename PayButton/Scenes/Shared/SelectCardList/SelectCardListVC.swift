//
//  SelectCardListVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit
import MOLH

protocol SelectCardListView: AnyObject {
    func didTapRadioButton(forCell selectedCell: CardListTblCell)
    func didTapCvvTextField(forCell selectedCell: CardListTblCell)
    func navigateToProcessingPaymentView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnResponse response: PayByCardReponse)
    func showErrorAlertView(withMessage errorMsg: String)
    func updateSavedCardList()
    func navigateToManageCardsView(withAllCardResponse: GetCustomerCardsResponse)
    func navigateToAddNewCardView(withCheckPaymentResponse response: PaymentMethodResponse)
    func startLoading()
    func endLoading()
}

class SelectCardListVC: UIViewController {
    
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
    
    @IBOutlet weak var closeCurrentPageBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var merchantLbl: UILabel!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    
    @IBOutlet weak var cardListTbl: UITableView!
    @IBOutlet weak var cardListTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectCardLbl: UILabel!
    @IBOutlet weak var manageCardsBtn: UIButton!
    @IBOutlet weak var addNewCardBtn: UIButton!

    var presenter: SelectCardListPresenter!
    
    private var selectedSavedCard: CardDetails?
    private var selectedCardCvv: String = ""
    private var selectedCardIndex: Int = 0
    
    weak var delegate: PayButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        self.setupUIView()
        addSpinnerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedSavedCard = presenter.getCustomerCards().cardsList?.first
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cardListTblHeight?.constant = self.cardListTbl.contentSize.height
    }
    
    private func addSpinnerView() {
        self.view.addSubview(loadingSpinner)
        loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func setupUIView() {
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
        + " " + String(format: "%.2f", MerchantDataManager.shared.merchant.amount)
        
        proceedBtn.setTitle("proceed".localizedString(), for: .normal)
        backBtn.setTitle("back".localizedString(), for: .normal)
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)
        
        cardListTbl.register(UINib(nibName: "CardListTblCell", bundle: nil),
                             forCellReuseIdentifier: "CardListTblCell")
        cardListTbl.dataSource = self
        cardListTbl.delegate = self
        cardListTbl.estimatedRowHeight = 100
        cardListTbl.rowHeight = UITableView.automaticDimension
        
        selectCardLbl.text = "select_card".localizedString()
        manageCardsBtn.setTitle("manage_cards".localizedString(), for: .normal)
        addNewCardBtn.setTitle("add_new_card".localizedString(), for: .normal)
    }
    
    @IBAction func manageCardsBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addNewCardBtnPressed(_ sender: UIButton) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = AddNewCardPresenter(view: viewController, paymentMethodData: presenter.getPaymentMethodData())
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
    }
    
    @IBAction func proceedBtnPressed(_ sender: UIButton) {
        if selectedCardCvv != "", let selectedCardId = selectedSavedCard?.cardID {
            startLoading()
            print("Card ID \n" + "\(selectedCardId)")
            presenter.getCustomerSession() { [weak self] sessionId in
                guard let self = self else { return }
                print("sessionId \n" + "\(sessionId)")
                presenter.callPayByCardAPI(customerSession: sessionId, cardID: selectedCardId, cvv: selectedCardCvv)
            }
        } else {
            for cell in cardListTbl.visibleCells as! [CardListTblCell] {
                if(cell.tag == selectedCardIndex) {
                    cell.hideCvvAlertLbl(state: false)
                } else {
                    cell.hideCvvAlertLbl(state: true)
                }
            }
        }
    }
    
    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if (MOLHLanguage.currentAppleLanguage()=="en") {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        }else{
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()
        
        let viewController = SelectCardListVC(nibName: "SelectCardListVC", bundle: nil)
        viewController.delegate = self.delegate
        let newPresenter = SelectCardListPresenter(view: viewController, paymentMethodData:
                                                    presenter.getPaymentMethodData(),
                                                   customerCards: presenter.getCustomerCards())
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

extension SelectCardListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCustomerCards().cardsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTblCell", for: indexPath) as! CardListTblCell
        cell.configure(presenter.getCustomerCards().cardsList?[indexPath.row])
        cell.tag = indexPath.row
        cell.delegate = presenter.view
        return cell
    }
}

extension SelectCardListVC: SelectCardListView {
    func didTapRadioButton(forCell selectedCell: CardListTblCell) {
        print("didTapToggleButton")
        selectedSavedCard = presenter.getCustomerCards().cardsList?[selectedCell.tag]
        selectedCardIndex = selectedCell.tag
        selectedCell.selectCardRadioBtn.isSelected = true
        selectedCell.hideCvvView(state: false)
        for cell in cardListTbl.visibleCells as! [CardListTblCell] {
            if(cell.tag != selectedCell.tag) {
                cell.selectCardRadioBtn.isSelected = false
                cell.hideCvvView(state: true)
            }
        }
    }
    
    func didTapCvvTextField(forCell selectedCell: CardListTblCell) {
        selectedCell.hideCvvAlertLbl(state: true)
        selectedCardCvv = selectedCell.cvvTextField.text ?? ""
        print(selectedCardCvv)
        if(selectedCardCvv.count == 3) {
            dismissKeyboard()
        }
    }
    
    func navigateToProcessingPaymentView(withUrlPath path: String) {
        print("navigateToProcessingPaymentView")
        let viewController = PaymentProcessingVC(nibName: "ProcessingCardDataVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = PaymentProcessingPresenter(view: viewController, urlPath: path)
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
        viewController.delegate = self.delegate
        
        let presenter = PaymentApprovedPresenter(view: viewController, payByCardResponse: response)
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
    
    func updateSavedCardList() {
        cardListTbl.reloadData()
    }
    
    func navigateToManageCardsView(withAllCardResponse: GetCustomerCardsResponse) {
        
    }
    
    func navigateToAddNewCardView(withCheckPaymentResponse response: PaymentMethodResponse) {
        let viewController = AddNewCardVC(nibName: "AddNewCardVC", bundle: nil)
        viewController.delegate = self.delegate
        
        let presenter = AddNewCardPresenter(view: viewController, paymentMethodData: response)
        viewController.presenter = presenter
        
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(viewController, animated: true)
        }
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
